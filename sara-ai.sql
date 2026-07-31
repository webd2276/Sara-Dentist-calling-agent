-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.patients (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  phone text NOT NULL UNIQUE,
  email text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT patients_pkey PRIMARY KEY (id)
);
CREATE TABLE public.bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  patient_id uuid,
  service_type text NOT NULL CHECK (service_type = ANY (ARRAY['Checkup'::text, 'Teeth Cleaning'::text, 'Filling'::text, 'Root Canal'::text, 'Teeth Whitening'::text, 'Braces Consult'::text, 'Emergency'::text])),
  appointment_date date NOT NULL,
  appointment_time time without time zone NOT NULL,
  status text NOT NULL DEFAULT 'confirmed'::text CHECK (status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'rescheduled'::text, 'cancelled'::text])),
  channel text NOT NULL CHECK (channel = ANY (ARRAY['call'::text, 'whatsapp'::text, 'web'::text, 'manual'::text])),
  google_calendar_event_id text,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT bookings_pkey PRIMARY KEY (id),
  CONSTRAINT bookings_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id)
);
CREATE TABLE public.activity_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  booking_id uuid,
  patient_id uuid,
  action text NOT NULL,
  description text NOT NULL,
  channel text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT activity_log_pkey PRIMARY KEY (id),
  CONSTRAINT activity_log_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id),
  CONSTRAINT activity_log_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id)
);
CREATE TABLE public.user_roles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  role USER-DEFINED NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_roles_pkey PRIMARY KEY (id)
);
CREATE TABLE public.admin_users (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  username text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT admin_users_pkey PRIMARY KEY (id)
);
CREATE TABLE public.login_sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  admin_user_id uuid,
  username text NOT NULL,
  login_at timestamp with time zone DEFAULT now(),
  logout_at timestamp with time zone,
  ip_address text,
  user_agent text,
  is_active boolean DEFAULT true,
  CONSTRAINT login_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT login_sessions_admin_user_id_fkey FOREIGN KEY (admin_user_id) REFERENCES public.admin_users(id)
);

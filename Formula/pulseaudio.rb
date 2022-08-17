class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git", branch: "master"

  stable do
    url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-16.1.tar.xz"
    sha256 "8eef32ce91d47979f95fd9a935e738cd7eb7463430dabc72863251751e504ae4"

    # Make gio-2.0 optional. Remove in the next release.
    patch do
      url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/de8b0c11242a49c335abdae292d0bb9f6d71d2dd.diff"
      sha256 "d2d259b887908b37d63564ee1eb93fa98a6bffc5600876c6181758c6ca59b95e"
    end
  end

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ce44a5a697ba790ab27e97f4c96cd5f48489cdfc416a836348584064053eb725"
    sha256 arm64_big_sur:  "efcbf144da932e05394e9768bf27dfa1908dbb17f4b7c52f49e56c791dd51860"
    sha256 monterey:       "835e284178eda5eaa8395aab875305d8ba528336f657844d5791f29e0216d46a"
    sha256 big_sur:        "79684acaac85e9b1b7de55fc7659844d9508c6264faa0aac311e0d8eaf4056b0"
    sha256 catalina:       "e1c181ae27f945ceee403e2e2ec80f44aebd52ac44b8e63140c1c9d2083a643b"
    sha256 mojave:         "ae0d2ec72fc10a895c7efc330174abef08458576ed847fb4547301a2d8cc147e"
    sha256 x86_64_linux:   "35c1358237eefe762c268cbbbf86015b425e8ff3bdff697afb93e8449fae2ae3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
    depends_on "libcap"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
      sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
    end
  end

  # Fix macOS build errors:
  # - ld: unknown option: -z
  # - ld: unknown option: -version-script=/private/tmp/pulseaudio-...
  # - ld: unknown option: --no-undefined
  # - Undefined symbols for architecture x86_64:
  #     "_AbsoluteToNanoseconds", referenced from:
  #         _pa_rtclock_age in pulsecore_core-rtclock.c.o
  #         _pa_rtclock_get in pulsecore_core-rtclock.c.o
  #         _pa_rtclock_from_wallclock in pulsecore_core-rtclock.c.o
  #         _pa_timeval_rtstore in pulsecore_core-rtclock.c.o
  #     "_pa_poll", referenced from:
  #         _pa_autospawn_lock_acquire in pulsecore_lock-autospawn.c.o
  #
  # FIXME: test error:
  # - E: [] ltdl-bind-now.c: Failed to open module .../module-allow-passthrough.so
  patch :DATA

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      resource("XML::Parser").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
        system "make", "install"
      end
    end

    system "meson", *std_meson_args, "build",
                    "-Dbashcompletiondir=#{bash_completion}",
                    "-Ddatabase=simple", # Default `tdb` isn't available in Homebrew
                    "-Ddoxygen=false",
                    "-Dlocalstatedir=#{var}",
                    "-Dman=true",
                    "-Dsysconfdir=#{etc}",
                    "-Dtests=false",
                    "-Dudevrulesdir=#{lib}/udev/rules.d",
                    "-Dx11=disabled"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    run [opt_bin/"pulseaudio", "--exit-idle-time=-1", "--verbose"]
    keep_alive true
    log_path var/"log/pulseaudio.log"
    error_log_path var/"log/pulseaudio.log"
  end

  test do
    output = shell_output("#{bin}/pulseaudio --dump-modules 2>&1")
    assert_match "module-sine", output
    refute_match "Failed to open module", output
  end
end

__END__
diff --git a/meson.build b/meson.build
index 9f47b2f02..133749ffd 100644
--- a/meson.build
+++ b/meson.build
@@ -150,7 +150,11 @@ cdata.set_quoted('PA_MACHINE_ID', join_paths(sysconfdir, 'machine-id'))
 cdata.set_quoted('PA_MACHINE_ID_FALLBACK', join_paths(localstatedir, 'lib', 'dbus', 'machine-id'))
 cdata.set_quoted('PA_SRCDIR', join_paths(meson.current_source_dir(), 'src'))
 cdata.set_quoted('PA_BUILDDIR', meson.current_build_dir())
-cdata.set_quoted('PA_SOEXT', '.so')
+if host_machine.system() == 'darwin'
+  cdata.set_quoted('PA_SOEXT', '.dylib')
+else
+  cdata.set_quoted('PA_SOEXT', '.so')
+endif
 cdata.set_quoted('PA_DEFAULT_CONFIG_DIR', pulsesysconfdir)
 cdata.set('PA_DEFAULT_CONFIG_DIR_UNQUOTED', pulsesysconfdir)
 cdata.set_quoted('PA_BINARY', join_paths(bindir, 'pulseaudio'))
@@ -425,12 +429,8 @@ cdata.set('MESON_BUILD', 1)
 # On ELF systems we don't want the libraries to be unloaded since we don't clean them up properly,
 # so we request the nodelete flag to be enabled.
 # On other systems, we don't really know how to do that, but it's welcome if somebody can tell.
-# Windows doesn't support this flag.
-if host_machine.system() != 'windows'
-  nodelete_link_args = ['-Wl,-z,nodelete']
-else
-  nodelete_link_args = []
-endif
+# macOS and Windows don't support this flag.
+nodelete_link_args = cc.get_supported_link_arguments('-Wl,-z,nodelete')

 # Code coverage

diff --git a/src/meson.build b/src/meson.build
index 9efb561d8..a6132f710 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -186,6 +186,11 @@ else
     'pulsecore/thread-posix.c'
   ]
 endif
+if host_machine.system() == 'darwin'
+  libpulsecommon_sources += [
+    'pulsecore/poll-posix.c'
+  ]
+endif
 # FIXME: Do SIMD things

 if not get_option('client')
diff --git a/src/modules/meson.build b/src/modules/meson.build
index 1e12569dc..c52f789f0 100644
--- a/src/modules/meson.build
+++ b/src/modules/meson.build
@@ -315,7 +315,7 @@ foreach m : all_modules
     install_rpath : rpath_dirs,
     install_dir : modlibexecdir,
     dependencies : [thread_dep, libpulse_dep, libpulsecommon_dep, libpulsecore_dep, libintl_dep, platform_dep, platform_socket_dep] + extra_deps,
-    link_args : [nodelete_link_args, '-Wl,--no-undefined' ],
+    link_args : [nodelete_link_args, cc.get_supported_link_arguments('-Wl,--no-undefined')],
     link_with : extra_libs,
     name_prefix : '',
     implicit_include_directories : false)
diff --git a/src/pulse/meson.build b/src/pulse/meson.build
index 1b82c807c..79f811a13 100644
--- a/src/pulse/meson.build
+++ b/src/pulse/meson.build
@@ -74,7 +74,7 @@ run_target('update-map-file',
   command : [ join_paths(meson.source_root(), 'scripts/generate-map-file.sh'), 'map-file',
               [ libpulse_headers, 'simple.h', join_paths(meson.build_root(), 'src', 'pulse', 'version.h') ] ])

-versioning_link_args = '-Wl,-version-script=' + join_paths(meson.source_root(), 'src', 'pulse', 'map-file')
+versioning_link_args = cc.get_supported_link_arguments('-Wl,-version-script=' + join_paths(meson.source_root(), 'src', 'pulse', 'map-file'))

 libpulse = shared_library('pulse',
   libpulse_sources,
diff --git a/src/pulsecore/core-rtclock.c b/src/pulsecore/core-rtclock.c
index 2c2e28631..d0cf15731 100644
--- a/src/pulsecore/core-rtclock.c
+++ b/src/pulsecore/core-rtclock.c
@@ -65,19 +65,7 @@ pa_usec_t pa_rtclock_age(const struct timeval *tv) {

 struct timeval *pa_rtclock_get(struct timeval *tv) {

-#if defined(OS_IS_DARWIN)
-    uint64_t val, abs_time = mach_absolute_time();
-    Nanoseconds nanos;
-
-    nanos = AbsoluteToNanoseconds(*(AbsoluteTime *) &abs_time);
-    val = *(uint64_t *) &nanos;
-
-    tv->tv_sec = val / PA_NSEC_PER_SEC;
-    tv->tv_usec = (val % PA_NSEC_PER_SEC) / PA_NSEC_PER_USEC;
-
-    return tv;
-
-#elif defined(HAVE_CLOCK_GETTIME)
+#if defined(HAVE_CLOCK_GETTIME)
     struct timespec ts;

 #ifdef CLOCK_MONOTONIC
@@ -97,6 +85,17 @@ struct timeval *pa_rtclock_get(struct timeval *tv) {
     tv->tv_sec = ts.tv_sec;
     tv->tv_usec = ts.tv_nsec / PA_NSEC_PER_USEC;

+    return tv;
+#elif defined(OS_IS_DARWIN)
+    uint64_t val, abs_time = mach_absolute_time();
+    Nanoseconds nanos;
+
+    nanos = AbsoluteToNanoseconds(*(AbsoluteTime *) &abs_time);
+    val = *(uint64_t *) &nanos;
+
+    tv->tv_sec = val / PA_NSEC_PER_SEC;
+    tv->tv_usec = (val % PA_NSEC_PER_SEC) / PA_NSEC_PER_USEC;
+
     return tv;
 #elif defined(OS_IS_WIN32)
     if (counter_freq > 0) {
diff --git a/src/pulsecore/creds.h b/src/pulsecore/creds.h
index b599b569c..b5b1c9f37 100644
--- a/src/pulsecore/creds.h
+++ b/src/pulsecore/creds.h
@@ -34,7 +34,7 @@
 typedef struct pa_creds pa_creds;
 typedef struct pa_cmsg_ancil_data pa_cmsg_ancil_data;

-#if defined(SCM_CREDENTIALS) || defined(SCM_CREDS)
+#if defined(SCM_CREDENTIALS) || (defined(SCM_CREDS) && !defined(__APPLE__))

 #define HAVE_CREDS 1


class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.8.13.tar.gz"
  sha256 "0328f61a5dce6f9cb16faa92d96f0a862cdb5644ff0855892ecc2f2228f7ea7b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff3087588fdcfb5ab39b8c419335b634cc16ccb0aebf128990a73f207ef15998"
    sha256 cellar: :any,                 arm64_big_sur:  "af53f4ef430d188794c4e306889c1f41b3cbe0399974f6931cd601f922ba4d13"
    sha256 cellar: :any,                 monterey:       "911a52d255749f0b47a10a8cc8d18ab90eb6e891f26797027054c191b7dc6b59"
    sha256 cellar: :any,                 big_sur:        "48adcc191333792e6c5f1a2cb7ba3f2cbc48650e43534aee766d6a930ccb2060"
    sha256 cellar: :any,                 catalina:       "92e510417cd9c46adaa6415a579798712d1eab1948ed13680b73e31afc35192c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a01bafce47685e30ce6d8ed49d61c0f4ae6f9ffa2a2a70f5d925fa6190ee296"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # Apply https://github.com/fluent/fluent-bit/pull/3564 to build on M1
  patch do
    url "https://github.com/fluent/fluent-bit/commit/fcdf304e5abc3e3b66b1acac76dbaf23b2d22579.patch?full_index=1"
    sha256 "80d1b0b6916ff1e0c157e6824afa769f08e28e764f65bfd28df0900d6f9bda1e"
  end

  # Fix error: use of undeclared identifier 'clock_serv_t'
  #
  # Also: don't install any service script for Linux
  patch :DATA

  def install
    chdir "build" do
      # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
      # is not set then it's forced to 10.4, which breaks compile on Mojave.
      # fluent-bit builds against a vendored Luajit.
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      system "cmake", "..", "-DWITH_IN_MEM=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end

__END__
diff --git a/lib/cmetrics/src/cmt_time.c b/lib/cmetrics/src/cmt_time.c
index 0671542a..67f1c368 100644
--- a/lib/cmetrics/src/cmt_time.c
+++ b/lib/cmetrics/src/cmt_time.c
@@ -20,7 +20,7 @@
 #include <cmetrics/cmt_info.h>

 /* MacOS */
-#ifdef FLB_HAVE_CLOCK_GET_TIME
+#ifdef CMT_HAVE_CLOCK_GET_TIME
 #include <mach/clock.h>
 #include <mach/mach.h>
 #endif
@@ -41,8 +41,8 @@ uint64_t cmt_time_now()
     mach_timespec_t mts;
     host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
     clock_get_time(cclock, &mts);
-    tm->tv_sec = mts.tv_sec;
-    tm->tv_nsec = mts.tv_nsec;
+    tm.tv_sec = mts.tv_sec;
+    tm.tv_nsec = mts.tv_nsec;
     mach_port_deallocate(mach_task_self(), cclock);
 #else /* __STDC_VERSION__ */
     clock_gettime(CLOCK_REALTIME, &tm);
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index f6654506..fe117172 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -434,27 +434,6 @@ if(FLB_BINARY)
       DESTINATION "${FLB_INSTALL_BINDIR}")
   endif()

-  # Detect init system, install upstart, systemd or init.d script
-  if(IS_DIRECTORY /lib/systemd/system)
-    set(FLB_SYSTEMD_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.service")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/systemd.in"
-      ${FLB_SYSTEMD_SCRIPT}
-      )
-    install(FILES ${FLB_SYSTEMD_SCRIPT} COMPONENT binary DESTINATION /lib/systemd/system)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR} COMPONENT binary)
-  elseif(IS_DIRECTORY /usr/share/upstart)
-    set(FLB_UPSTART_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.conf")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/upstart.in"
-      ${FLB_UPSTART_SCRIPT}
-      )
-    install(FILES ${FLB_UPSTART_SCRIPT} COMPONENT binary DESTINATION /etc/init)
-    install(DIRECTORY DESTINATION COMPONENT binary ${FLB_INSTALL_CONFDIR})
-  else()
-    # FIXME: should we support Sysv init script ?
-  endif()
-
   install(FILES
     "${PROJECT_SOURCE_DIR}/conf/fluent-bit.conf"
     DESTINATION ${FLB_INSTALL_CONFDIR}
diff --git a/src/flb_time.c b/src/flb_time.c
index 9f3d5964..bdc89d7e 100644
--- a/src/flb_time.c
+++ b/src/flb_time.c
@@ -52,13 +52,13 @@ static int _flb_time_get(struct flb_time *tm)
 #elif defined FLB_HAVE_TIMESPEC_GET
     /* C11 supported! */
     return timespec_get(&tm->tm, TIME_UTC);
-#elif defined FLB_CLOCK_GET_TIME
+#elif defined FLB_HAVE_CLOCK_GET_TIME
     clock_serv_t cclock;
     mach_timespec_t mts;
     host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
     clock_get_time(cclock, &mts);
-    tm->tv_sec = mts.tv_sec;
-    tm->tv_nsec = mts.tv_nsec;
+    tm->tm.tv_sec = mts.tv_sec;
+    tm->tm.tv_nsec = mts.tv_nsec;
     return mach_port_deallocate(mach_task_self(), cclock);
 #else /* __STDC_VERSION__ */
     return clock_gettime(CLOCK_REALTIME, &tm->tm);

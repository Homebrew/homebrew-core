class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.8.11.tar.gz"
  sha256 "52273a0281ee1afe0088d88a54462a424ce88181ca76f72daab7c2b96d2994c2"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ceebfd84afa9735969221f46cac71626f656ecc6e34fb885ee75914bf5e3b5a"
    sha256 cellar: :any,                 arm64_big_sur:  "64c4d9691eb0c9246fd290af3ed3b600e8106d774f16a8c43c32acfa0f65ba75"
    sha256 cellar: :any,                 monterey:       "e6be47a2d791ae8accbbebeb3aa026a1cbfbd770b09eafcea13082ee0cc38382"
    sha256 cellar: :any,                 big_sur:        "72f4293f8a931312a1b0333bfcccde9ef4803419c66e7b31caa88cba021e3d2b"
    sha256 cellar: :any,                 catalina:       "97825094ec05a4c6fca0dc8fcbb255c35b7ae3e8622fee0b2f360e7d819880cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a36e4454b4fec670a72b3f99ffc73202af1bd70eb20a5384b2adbf1d275d50d7"
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

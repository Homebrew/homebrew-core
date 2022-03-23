class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.8.15.tar.gz"
  sha256 "b98328c7e7c2428389fa2b284abe8d2c901c3365701ce05e51abcf550d9fd39a"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3258422aacc0235db6b2701db0557907d6802a9b99936caf1154e840768b8672"
    sha256 cellar: :any,                 arm64_big_sur:  "7d0bf37cd794c7b56216458a6f3196c9cf7f3bd0153cb8d72101bae151500dba"
    sha256 cellar: :any,                 monterey:       "284efdeebec48481ab1f9c98f358483c39b422049756bdcdd2e179f349ca7855"
    sha256 cellar: :any,                 big_sur:        "1eeae8b0ec546211e01840f2bde0911c9c68fbe4d6d5ceade33b02bdfd667619"
    sha256 cellar: :any,                 catalina:       "88dd3813c5220acf34f9d71d6a29229adf3bf8b1903e1b02fb4a05910a84afa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c58015cd9252b6ddc78119d703d698b810b101cf1efe60313a9108034f346a"
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

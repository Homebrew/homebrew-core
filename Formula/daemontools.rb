class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://cr.yp.to/daemontools.html"
  url "https://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"
  revision 1

  livecheck do
    url "https://cr.yp.to/daemontools/install.html"
    regex(/href=.*?daemontools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3e38b536653bd1b7e2e8d0e98dca15f9085205d3eeed09d8d1787afe468a08b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66a2fccba83ee8fe623c06d8b53dfb241cdeffd4af6ccdd8ac499c5b3191a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4970abde6563bd8fa9cae9478b81d241ce0ad0c4d1504aa84269c55ccb45a499"
    sha256 cellar: :any_skip_relocation, ventura:        "73a2cd834d4b1ef90c48199eaaaba09f077d153252b1d383a4a619a211b1eab7"
    sha256 cellar: :any_skip_relocation, monterey:       "23c7f34339a55c30a0e32c45b200030e766eeae0fc7cc873de70bae175849123"
    sha256 cellar: :any_skip_relocation, big_sur:        "2de015542410e14eb8e17bb9affc37f19fc81e7005e4bec60ecd64c13629b02a"
    sha256 cellar: :any_skip_relocation, catalina:       "0a39db96c9e2926beea8224ca844264d4ddec3b6561d5dfc019f3ecfd7cc86fe"
    sha256 cellar: :any_skip_relocation, mojave:         "6516ee63288eab3eab3ee418ce070d711f483a5f6ebc147cb7039a9404bbaa0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d33be57d88799bbac35d167147869dbc93786d165d608a6e3286ff769af6343"
  end

  # Fix build failure due to missing #include <errno.h> on Linux.
  # Patch submitted to author by email.
  patch :DATA

  def install
    cd "daemontools-#{version}" do
      inreplace ["package/run", "src/svscanboot.sh"] do |s|
        s.gsub! "/service", "#{etc}/service"
      end

      # Work around build error from root requirement: "Oops. Your getgroups() returned 0,
      # and setgroups() failed; this means that I can't reliably do my shsgr test. Please
      # either ``make'' as root or ``make'' while you're in one or more supplementary groups."
      inreplace "src/Makefile", "( cat warn-shsgr; exit 1 )", "cat warn-shsgr" if OS.linux?

      system "package/compile"
      bin.install Dir["command/*"]
    end
  end

  def post_install
    (etc/"service").mkpath

    Pathname.glob("/service/*") do |original|
      target = "#{etc}/service/#{original.basename}"
      ln_s original, target unless File.exist?(target)
    end
  end

  def caveats
    <<~EOS
      Services are stored in:
        #{etc}/service/
    EOS
  end

  plist_options startup: true

  service do
    run opt_bin/"svscanboot"
    keep_alive true
  end

  test do
    assert_match "Homebrew", shell_output("#{bin}/softlimit -t 1 echo 'Homebrew'")
  end
end

__END__
diff --git a/daemontools-0.76/src/alloc.c b/daemontools-0.76/src/alloc.c
index c741aa4..418f774 100644
--- a/daemontools-0.76/src/alloc.c
+++ b/daemontools-0.76/src/alloc.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include "alloc.h"
 #include "error.h"
+#include "errno.h"
 
 #define ALIGNMENT 16 /* XXX: assuming that this alignment is enough */
 #define SPACE 2048 /* must be multiple of ALIGNMENT */
diff --git a/daemontools-0.76/src/buffer_get.c b/daemontools-0.76/src/buffer_get.c
index 3a6e1b6..1d8b584 100644
--- a/daemontools-0.76/src/buffer_get.c
+++ b/daemontools-0.76/src/buffer_get.c
@@ -3,6 +3,7 @@
 #include "buffer.h"
 #include "byte.h"
 #include "error.h"
+#include "errno.h"
 
 static int oneread(int (*op)(),int fd,char *buf,unsigned int len)
 {
diff --git a/daemontools-0.76/src/buffer_put.c b/daemontools-0.76/src/buffer_put.c
index 23164b3..e41940d 100644
--- a/daemontools-0.76/src/buffer_put.c
+++ b/daemontools-0.76/src/buffer_put.c
@@ -4,6 +4,7 @@
 #include "str.h"
 #include "byte.h"
 #include "error.h"
+#include "errno.h"
 
 static int allwrite(int (*op)(),int fd,const char *buf,unsigned int len)
 {
diff --git a/daemontools-0.76/src/envdir.c b/daemontools-0.76/src/envdir.c
index beb1b1f..7fd901c 100644
--- a/daemontools-0.76/src/envdir.c
+++ b/daemontools-0.76/src/envdir.c
@@ -2,6 +2,7 @@
 #include "byte.h"
 #include "open.h"
 #include "error.h"
+#include "errno.h"
 #include "direntry.h"
 #include "stralloc.h"
 #include "openreadclose.h"
diff --git a/daemontools-0.76/src/fghack.c b/daemontools-0.76/src/fghack.c
index 34ca1db..d692f95 100644
--- a/daemontools-0.76/src/fghack.c
+++ b/daemontools-0.76/src/fghack.c
@@ -1,6 +1,7 @@
 #include <unistd.h>
 #include "wait.h"
 #include "error.h"
+#include "errno.h"
 #include "strerr.h"
 #include "buffer.h"
 #include "pathexec.h"
diff --git a/daemontools-0.76/src/multilog.c b/daemontools-0.76/src/multilog.c
index be27a6a..e0c8053 100644
--- a/daemontools-0.76/src/multilog.c
+++ b/daemontools-0.76/src/multilog.c
@@ -6,6 +6,7 @@
 #include "buffer.h"
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 #include "lock.h"
 #include "scan.h"
diff --git a/daemontools-0.76/src/openreadclose.c b/daemontools-0.76/src/openreadclose.c
index 635933b..5500c61 100644
--- a/daemontools-0.76/src/openreadclose.c
+++ b/daemontools-0.76/src/openreadclose.c
@@ -1,6 +1,7 @@
 /* Public domain. */
 
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 #include "readclose.h"
 #include "openreadclose.h"
diff --git a/daemontools-0.76/src/pathexec_run.c b/daemontools-0.76/src/pathexec_run.c
index 1770ac7..eed116f 100644
--- a/daemontools-0.76/src/pathexec_run.c
+++ b/daemontools-0.76/src/pathexec_run.c
@@ -1,6 +1,7 @@
 /* Public domain. */
 
 #include "error.h"
+#include "errno.h"
 #include "stralloc.h"
 #include "str.h"
 #include "env.h"
diff --git a/daemontools-0.76/src/readclose.c b/daemontools-0.76/src/readclose.c
index 9d83007..8fcf493 100644
--- a/daemontools-0.76/src/readclose.c
+++ b/daemontools-0.76/src/readclose.c
@@ -2,6 +2,7 @@
 
 #include <unistd.h>
 #include "error.h"
+#include "errno.h"
 #include "readclose.h"
 
 int readclose_append(int fd,stralloc *sa,unsigned int bufsize)
diff --git a/daemontools-0.76/src/readproctitle.c b/daemontools-0.76/src/readproctitle.c
index 82fbffd..b891474 100644
--- a/daemontools-0.76/src/readproctitle.c
+++ b/daemontools-0.76/src/readproctitle.c
@@ -1,5 +1,6 @@
 #include <unistd.h>
 #include "error.h"
+#include "errno.h"
 
 int main(int argc,char **argv)
 {
diff --git a/daemontools-0.76/src/strerr_sys.c b/daemontools-0.76/src/strerr_sys.c
index 84b302f..ec47c90 100644
--- a/daemontools-0.76/src/strerr_sys.c
+++ b/daemontools-0.76/src/strerr_sys.c
@@ -1,6 +1,7 @@
 /* Public domain. */
 
 #include "error.h"
+#include "errno.h"
 #include "strerr.h"
 
 struct strerr strerr_sys;
diff --git a/daemontools-0.76/src/supervise.c b/daemontools-0.76/src/supervise.c
index 2482ad2..5adb774 100644
--- a/daemontools-0.76/src/supervise.c
+++ b/daemontools-0.76/src/supervise.c
@@ -5,6 +5,7 @@
 #include "sig.h"
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "fifo.h"
 #include "open.h"
 #include "lock.h"
diff --git a/daemontools-0.76/src/svc.c b/daemontools-0.76/src/svc.c
index 4a8c8c1..ff8bfc4 100644
--- a/daemontools-0.76/src/svc.c
+++ b/daemontools-0.76/src/svc.c
@@ -2,6 +2,7 @@
 #include "ndelay.h"
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 #include "sgetopt.h"
 #include "buffer.h"
diff --git a/daemontools-0.76/src/svok.c b/daemontools-0.76/src/svok.c
index d29abcc..18c458e 100644
--- a/daemontools-0.76/src/svok.c
+++ b/daemontools-0.76/src/svok.c
@@ -1,6 +1,7 @@
 #include <unistd.h>
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 
 #define FATAL "svok: fatal: "
diff --git a/daemontools-0.76/src/svscan.c b/daemontools-0.76/src/svscan.c
index 15a8c89..e8bf0e3 100644
--- a/daemontools-0.76/src/svscan.c
+++ b/daemontools-0.76/src/svscan.c
@@ -4,6 +4,7 @@
 #include "direntry.h"
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "wait.h"
 #include "coe.h"
 #include "fd.h"
diff --git a/daemontools-0.76/src/svstat.c b/daemontools-0.76/src/svstat.c
index fcc4732..cddbcf7 100644
--- a/daemontools-0.76/src/svstat.c
+++ b/daemontools-0.76/src/svstat.c
@@ -3,6 +3,7 @@
 #include <sys/stat.h>
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 #include "fmt.h"
 #include "tai.h"
diff --git a/daemontools-0.76/src/wait_pid.c b/daemontools-0.76/src/wait_pid.c
index c2869b8..91c0fb1 100644
--- a/daemontools-0.76/src/wait_pid.c
+++ b/daemontools-0.76/src/wait_pid.c
@@ -3,6 +3,7 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 #include "error.h"
+#include "errno.h"
 #include "haswaitp.h"
 
 #ifdef HASWAITPID

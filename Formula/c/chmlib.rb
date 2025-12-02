class Chmlib < Formula
  desc "Library for dealing with Microsoft ITSS/CHM files"
  homepage "http://www.jedrea.com/chmlib/"
  url "http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz"
  sha256 "512148ed1ca86dea051ebcf62e6debbb00edfdd9720cde28f6ed98071d3a9617"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?chmlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "023b19e53523d58babcd983aba314c758781ecfdcde1b76881d4b7f99503b7dc"
    sha256 cellar: :any,                 arm64_sequoia:  "035ec89221398776eb098d776c5f451a7d065e3f0ceaf665742c7c9bf9568f16"
    sha256 cellar: :any,                 arm64_sonoma:   "c102db33eb3d9dfc3f42ef40bd044a59f1d88471c8057106909311ca4285d488"
    sha256 cellar: :any,                 arm64_ventura:  "fb27ebeee48d99f6637aae0da57043863119406a49fafe09deac78badcb723f8"
    sha256 cellar: :any,                 arm64_monterey: "23e464348836e12bf5835bfdf1acbcdcce344151d12cfa2a055d689c205b6e82"
    sha256 cellar: :any,                 arm64_big_sur:  "3ab46a541a6aeb2ac904a74fa1433e48bfca91a382e8e8b27290d0597581f520"
    sha256 cellar: :any,                 sonoma:         "a2d5310e0320a5d7bcf868c63302811c1148351cbd52c53f5d8a526542244525"
    sha256 cellar: :any,                 ventura:        "73986282be1f4d01cfdaebb1aa2b68683143a60acd35cf67235ed8d4f8f0df31"
    sha256 cellar: :any,                 monterey:       "4d4a29e60712457e4ea3838947a95959dbc0f68338514edd3817d6ee122afbf4"
    sha256 cellar: :any,                 big_sur:        "af369d3e427b36281f053f65a0d5be2a269c2a0fb80c87443baa066892d0652c"
    sha256 cellar: :any,                 catalina:       "96d7cb33260c72012f24f383054b7f2505f815f0e3e24298229b5712f8a66cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dc0799919a7cc91ec7505ec8e8a7290baa38342a10e4e4ca9017f417ffda95c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a085287bba377e847d027575fd848cbadc0f6b5bd8f2efc008cc54d8f32d32"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Add aarch64 to 64-bit integer platform list.
  # Fix implicit function declarations, for C99 compatibility: https://github.com/jedwing/CHMLib/pull/17
  patch :DATA

  def install
    args = %W[
      --disable-io64
      --enable-examples
      --prefix=#{prefix}
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <chm_lib.h>
      int main() {
        struct chmFile* chm = chm_open("file-that-doesnt-exist.chm");
        return chm != 0; // Fail if non-null.
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lchm", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/src/chm_lib.c b/src/chm_lib.c
index 6c6736c..06908c0 100644
--- a/src/chm_lib.c
+++ b/src/chm_lib.c
@@ -164,7 +164,7 @@ typedef unsigned long long      UInt64;

 /* x86-64 */
 /* Note that these may be appropriate for other 64-bit machines. */
-#elif __x86_64__ || __ia64__
+#elif __x86_64__ || __ia64__ || __aarch64__
 typedef unsigned char           UChar;
 typedef short                   Int16;
 typedef unsigned short          UInt16;
diff --git a/src/chm_http.c b/src/chm_http.c
index 237e85a..1df2adb 100644
--- a/src/chm_http.c
+++ b/src/chm_http.c
@@ -43,6 +43,8 @@
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <netinet/in.h>
+#include <arpa/inet.h>
+#include <unistd.h>

 /* threading includes */
 #include <pthread.h>
diff --git a/src/chm_lib.c b/src/chm_lib.c
index ffd213c..9eb9d1b 100644
--- a/src/chm_lib.c
+++ b/src/chm_lib.c
@@ -48,6 +48,8 @@
  *                                                                         *
  ***************************************************************************/

+#define _LARGEFILE64_SOURCE /* for pread64 */
+
 #include "chm_lib.h"

 #ifdef CHM_MT

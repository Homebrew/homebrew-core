class Cmuclmtk < Formula
  desc "Language model tools (from CMU Sphinx)"
  homepage "https://cmusphinx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cmusphinx/cmuclmtk/0.7/cmuclmtk-0.7.tar.gz"
  sha256 "d23e47f00224667c059d69ac942f15dc3d4c3dd40e827318a6213699b7fa2915"
  license "BSD-2-Clause"

  # We check the "cmuclmtk" directory page since versions aren't present in the
  # RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/cmusphinx/files/cmuclmtk/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e382dbebb03c49d129bb2eacd23102d828d9814296bb751f275e2bd5cd4ac8e4"
    sha256 cellar: :any,                 arm64_sequoia:  "17749777bf2cedd02ab511ce2bab36a69389ea9c1f0b03c8a92927e3e54a5fae"
    sha256 cellar: :any,                 arm64_sonoma:   "1fe5f5fcb73a7580ae29500204bc6efb7073a5b9359dbadf0b045bc358de7697"
    sha256 cellar: :any,                 arm64_ventura:  "5c31b85c5a4c5696e53b70dca952b11cd009b4c2755dd8339d1fde8b61921047"
    sha256 cellar: :any,                 arm64_monterey: "6f336006d80dbcfce530db381fb28d6207953c9ba792f71c31f041b983b85c53"
    sha256 cellar: :any,                 arm64_big_sur:  "d3069c3fbd0f41bdb0b3435b7b388f9e6051639421658663185bde9a449185b8"
    sha256 cellar: :any,                 sonoma:         "1585ae5f93e266d9189c985072808f6731b1ce52c75cc58d2caf4c27ec9edf4f"
    sha256 cellar: :any,                 ventura:        "a8e37d15ba21ee7acd391691ebf4f27b585ca9badde68492b828c1a218ef6799"
    sha256 cellar: :any,                 monterey:       "0d6891a3cb5d5be6b4071bcf68a9e3449d9a79c37b4c660f1044bbc93ecafcfa"
    sha256 cellar: :any,                 big_sur:        "e126c9d5de2e1f4e23d4fea7e8ac51c6fc2d4328a968c907879f4ea86524fbbc"
    sha256 cellar: :any,                 catalina:       "fb552e12a3c59e2ca6a9dd89e9ec229e5b815edef28093c3902fc4ee54b52207"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fbf62c45fadfecaf2d9cd51668c6ea132d904afe1e456f099f067427667b1284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708324bb6cf751c76f927c6a648416ee38012499dddfc80c4b2c50cf36431c4d"
  end

  depends_on "pkgconf" => :build

  conflicts_with "julius", because: "both install `binlm2arpa` binaries"

  # Fix errors: call to undeclared function '***';
  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  patch :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/text2wfreq", "Hello Hello Homebrew")
    assert_match "Hello 2", output
    assert_match "Homebrew 1", output
  end
end

__END__
diff --git a/src/libs/rr_mkdtemp.c b/src/libs/rr_mkdtemp.c
index 50441ce..ee1f1c5 100755
--- a/src/libs/rr_mkdtemp.c
+++ b/src/libs/rr_mkdtemp.c
@@ -36,6 +36,7 @@

 #include <stdio.h>
 #include <stdlib.h>
+#include <sys/stat.h>

 #include <../win32/compat.h>

diff --git a/src/programs/text2idngram.c b/src/programs/text2idngram.c
index 1ec1cc2..b9ba37b 100644
--- a/src/programs/text2idngram.c
+++ b/src/programs/text2idngram.c
@@ -53,6 +53,8 @@
 #include <string.h>
 #include <sys/types.h>
 #include <errno.h>
+#include <sys/stat.h>
+#include <unistd.h>

 #include "../liblmest/toolkit.h"
 #include "../libs/general.h"
diff --git a/src/programs/text2wngram.c b/src/programs/text2wngram.c
index 22ba67d..2790fde 100644
--- a/src/programs/text2wngram.c
+++ b/src/programs/text2wngram.c
@@ -41,11 +41,14 @@
 #include <string.h>
 #include <stdlib.h>
 #include <errno.h>
+#include <sys/stat.h>
+#include <unistd.h>

 #include "../liblmest/toolkit.h"
 #include "../libs/pc_general.h"
 #include "../libs/general.h"
 #include "../win32/compat.h"
+#include "../libs/ac_lmfunc_impl.h"

 int cmp_strings(const void *string1,const void *string2) {

diff --git a/src/programs/wngram2idngram.c b/src/programs/wngram2idngram.c
index 3f2ba57..e363282 100644
--- a/src/programs/wngram2idngram.c
+++ b/src/programs/wngram2idngram.c
@@ -47,6 +47,8 @@
 #include <string.h>
 #include <sys/types.h>
 #include <errno.h>
+#include <sys/stat.h>
+#include <unistd.h>

 #include "../liblmest/toolkit.h"
 #include "../libs/general.h"

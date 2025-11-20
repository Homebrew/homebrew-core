class Bsdiff < Formula
  desc "Generate and apply patches to binary files"
  homepage "https://www.daemonology.net/bsdiff/"
  # Returns 403 (forbidden) for the canonical download URL:
  # "https://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz"
  url "https://deb.debian.org/debian/pool/main/b/bsdiff/bsdiff_4.3.orig.tar.gz"
  sha256 "18821588b2dc5bf159aa37d3bcb7b885d85ffd1e19f23a0c57a58723fea85f48"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?bsdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c1b39ac523c9bb26c5b194c20451b28be15bf1a8a5b59bab50a517f7619c472d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5aa138e7ada53aa574d2bf31f2cfa65cd53692001a1d7e5ad6240fc72975d6b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dac6fb313e1df3f6c05870f8accc2f65615924124b9b24b481dc0c4e5f77193"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e83875207f8cc492079e701ba371bb08c89aaea95d47c0aa1d78069376dced12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "141219925cf9d52e796d9bce068bf747d32e5f5c9b486c3eaf539b59980062dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "810dccf063f4876a5786e4aa7f7584ebcf5205fec1abd0882cead7e0de16bca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebe5b95b664031daacd3c13c259b36dacf96b014de8f391ba3c16049764758f0"
    sha256 cellar: :any_skip_relocation, ventura:        "a48083deaf3e24c5c364aeb4503cbceee406a980b63fa764df92d23798c95283"
    sha256 cellar: :any_skip_relocation, monterey:       "e0cf74e5fb1ef71fd68a33595f0dcc6d777d72e90689f57976e5c1784b1496a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f1f498a32a8804a238cf8dce1ba7cebbee070ae6bf0bb4015dcb133ab155574"
    sha256 cellar: :any_skip_relocation, catalina:       "648a52a8af8e8f17feb9e34168dd0f00abfc98e9f0f3aa7fd88fb1458a782098"
    sha256                               arm64_linux:    "bb201ab0bfbc684057c632420b2a69c2b568ccf547a7c121096806bd6c836d8f"
    sha256                               x86_64_linux:   "a48ec4c541d81798cb3ba5706f031a7e71a8da01154eef1df353a729d2614130"
  end

  depends_on "bmake" => :build

  uses_from_macos "bzip2"

  patch :DATA

  def install
    ENV.append "LDLIBS", "-lbz2" unless OS.mac?
    system "bmake"
    bin.install "bsdiff"
    man1.install "bsdiff.1"
  end

  test do
    (testpath/"bin1").write "\x01\x02\x03\x04"
    (testpath/"bin2").write "\x01\x02\x03\x05"

    system bin/"bsdiff", "bin1", "bin2", "bindiff"
  end
end

__END__
diff --git a/bspatch.c b/bspatch.c
index 643c60b..543379c 100644
--- a/bspatch.c
+++ b/bspatch.c
@@ -28,6 +28,7 @@
 __FBSDID("$FreeBSD: src/usr.bin/bsdiff/bspatch/bspatch.c,v 1.1 2005/08/06 01:59:06 cperciva Exp $");
 #endif

+#include <sys/types.h>
 #include <bzlib.h>
 #include <stdlib.h>
 #include <stdio.h>

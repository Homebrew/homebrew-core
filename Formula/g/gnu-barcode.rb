class GnuBarcode < Formula
  desc "Convert text strings to printed bars"
  homepage "https://www.gnu.org/software/barcode/"
  url "https://ftpmirror.gnu.org/gnu/barcode/barcode-0.99.tar.gz"
  mirror "https://ftp.gnu.org/gnu/barcode/barcode-0.99.tar.gz"
  sha256 "7c031cf3eb811242f53664379aebbdd9fae0b7b26b5e5d584c31a9f338154b64"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "57fbf7e1c8368b3405d771acfaff14d5f41d970681575c4e45484a8760a37a02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "30ba34d1c972ec24c6f5ccd484585cd114456d7a6523f16f31dcf58c81089663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d037ed37810d7bd12b7e915857ec6789445d67ac197ba328102099ce8e00e781"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef4c6bfacdcb641696dbc98dd7baf68fadab846c1e80c5e42e75ad068e327336"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed996c9d8421dcd926b85eefc7e3dd04cc9d9430f72f0b466f62647a5f322e94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e621e1e142ab7c323b6bc133b4b3c373df050986e4282814f07a8ca1928d83c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdc959e1f896a2d8d009bc700ded086d9675facce052e08e9146724e97fa0a69"
    sha256 cellar: :any_skip_relocation, ventura:        "930679d903dca0fa945427cd97be4243a047e17c8be5e1f8085ddd34c13d5ec2"
    sha256 cellar: :any_skip_relocation, monterey:       "8442ab838d1f32813d7e8ffc4efec8a5c9bc32241cdbb8a9a3acd4efe506ff9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8db9cd7477dfce32af8a9451c792683d97ef0ab81d7929881ac59a6fab9d88aa"
    sha256 cellar: :any_skip_relocation, catalina:       "237ba00c7acb6a0343b17cae529d6a854ae321a03136d0f2882b010f4107230c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9a87f687d36fddc89efcd6e0f668d483b6630617dd51179ed27a4e29f26176a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cea83cbded5ce1bf557f237984a5085ba5b5534980c64e0b7d97e6756ab01dd"
  end

  # Patch and ac_cv_func_calloc_0_nonnull config addresses the following issue:
  # https://lists.gnu.org/archive/html/bug-barcode/2015-06/msg00001.html
  patch :DATA

  def install
    system "./configure", "ac_cv_func_calloc_0_nonnull=yes",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "MAN1DIR=#{man1}",
                   "MAN3DIR=#{man3}",
                   "INFODIR=#{info}",
                   "install"
  end

  test do
    (testpath/"test.txt").write("12345")
    system bin/"barcode", "-e", "CODE39", "-i", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end

__END__
diff -bur barcode-original/barcode.h barcode-new/barcode.h
--- barcode-original/barcode.h  2013-03-29 16:51:07.000000000 -0500
+++ barcode-new/barcode.h       2015-08-16 16:06:23.000000000 -0500
@@ -123,6 +123,6 @@
 }
 #endif

-int streaming;
+extern int streaming;

 #endif /* _BARCODE_H_ */
diff -bur barcode-original/pcl.c barcode-new/pcl.c
--- barcode-original/pcl.c      2013-03-29 17:23:31.000000000 -0500
+++ barcode-new/pcl.c   2015-08-16 16:07:06.000000000 -0500
@@ -29,6 +29,7 @@

 #define SHRINK_AMOUNT 0.15  /* shrink the bars to account for ink spreading */

+int streaming;

 /*
  * How do the "partial" and "textinfo" strings work? See file "ps.c"

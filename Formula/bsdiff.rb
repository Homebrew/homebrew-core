class Bsdiff < Formula
  desc "Generate and apply patches to binary files"
  homepage "http://www.daemonology.net/bsdiff"
  url "http://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz"
  sha256 "18821588b2dc5bf159aa37d3bcb7b885d85ffd1e19f23a0c57a58723fea85f48"

  bottle do
    cellar :any_skip_relocation
    sha256 "c21cd31202c096b99788346b22a3aeaddd72b397b2ae6cbd971926ba93d9f541" => :sierra
    sha256 "4b4e2e68dc5ffa9a5fc02b6c59c4d8201d8d6df8d5e6aef5bd70854ecbe917b7" => :el_capitan
    sha256 "79d0ef36a33a214595c66a70d8197a1eb148bcd3c1d1c782d28fc20f6a057d43" => :yosemite
    sha256 "26899c5d4e34ccfde4633b78a8cbbdf3036f028dfb16767fb2ac64efb2296b56" => :mavericks
  end

  depends_on "bsdmake" => :build

  patch :DATA

  def install
    system "bsdmake"
    bin.install "bsdiff"
    man1.install "bsdiff.1"
  end

  test do
    (testpath/"bin1").write "\x01\x02\x03\x04"
    (testpath/"bin2").write "\x01\x02\x03\x05"

    system "#{bin}/bsdiff", "bin1", "bin2", "bindiff"
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

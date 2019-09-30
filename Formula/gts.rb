class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "https://gts.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "9cc937ab4e7ede848f01e8665659fae24d3c578c5aaeed0276831c17d59db647" => :catalina
    sha256 "59aa61dfb703ff1c0cea21d248acf8d9a426115155f1f2ec1e5a1db6f71e66b4" => :mojave
    sha256 "41a917173c363d9cf94e72bcfb58cabc874bf44fc265d3ca4d9a0fbd979ad8ad" => :high_sierra
    sha256 "b35a110b45532e59b9f19e361984359e8bf92823b496f885eafdcbc134b18b17" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "netpbm"

  # Fix for newer netpbm.
  # This software hasn't been updated in seven years
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end

__END__
diff --git a/examples/happrox.c b/examples/happrox.c
index 88770a8..11f140d 100644
--- a/examples/happrox.c
+++ b/examples/happrox.c
@@ -21,7 +21,7 @@
 #include <stdlib.h>
 #include <locale.h>
 #include <string.h>
-#include <pgm.h>
+#include <netpbm/pgm.h>
 #include "config.h"
 #ifdef HAVE_GETOPT_H
 #  include <getopt.h>

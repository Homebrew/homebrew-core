class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "https://gts.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "efa1e3990e707e16709bbd258502b9c248c25bb5468e8a7b3ef491c56c3a180a"
    sha256 cellar: :any,                 big_sur:       "659f27e7e8ab695125ffe0175bf4d915f5e5618fcae0c425180fc085c3388d41"
    sha256 cellar: :any,                 catalina:      "8a0c9b4f60a2cbea2e2e3469880284c2373843e676aaf58c1ff28d1e31c2ccb9"
    sha256 cellar: :any,                 mojave:        "e0ba5b2700ba2a0c88a6345117a699c08f47738d3e727dbc64d815d1a3b7492b"
    sha256 cellar: :any,                 high_sierra:   "5aa85562ed3d0aad446825d7c4e3cc717f8044a2c638bbdcdd0e18bc0f366e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8574a923a6854116b836f04ffdd0b556d71c3e63da1127a90c2e6ac573900c88"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "netpbm"

  conflicts_with "pcb", because: "both install a `gts.h` header"

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

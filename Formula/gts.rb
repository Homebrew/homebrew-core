class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "https://gts.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"

  bottle do
    cellar :any
    sha256 "b06c43a504c4eb51317113e7c2849250bce0110be6ec9c7df832ae0d8e8e4771" => :mojave
    sha256 "d52dda8d2163b4116aa2bbfd9ea87cf468e58933059529f18089e7b82dfdeb95" => :high_sierra
    sha256 "00e18cd7e72fe3d9c2dbb4610d1bb6c2a7653b8831bd3b4b15dd8c2736ee62db" => :sierra
    sha256 "c958735937a398843e9a2b2cc1a1b9bc5305834de4257f1715a12dcc84b25f75" => :el_capitan
    sha256 "1c6b31293f1db0384813fc935d0e9649e41fd46440363caf32da363d27328fd7" => :yosemite
    sha256 "b6e2ce541c5b4b46076843076c6842723a896afa36619cfab8155194795c9817" => :mavericks
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

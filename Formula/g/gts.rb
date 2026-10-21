class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "https://gts.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"
  license "LGPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "afea12b155fa2547184e9bd141a4233248a3a450206d12b9a0750176e532f4fc"
    sha256 cellar: :any, arm64_tahoe:       "a60842b845a7fd3e0ad73585b480df78179191296017ecd10761806968a62c15"
    sha256 cellar: :any, arm64_sequoia:     "bb888bdb6f17cda6bca9801f286b8038b63f45298dd5b8f9948c8f51900907ec"
    sha256 cellar: :any, arm64_linux:       "67091279cbbbaec014b36d797679a77090f1f7a76ca17ec560bcd67d3ef81320"
    sha256 cellar: :any, x86_64_linux:      "e3af7824ad48ccca81064229d4f3062b3fb82173a204f8f8ebe44af3c1a8c9a1"
  end

  # We regenerate configure to avoid the `-flat_namespace` flag.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "netpbm"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "pcb", because: "both install a `gts.h` header"

  # Fix for newer netpbm.
  # This software hasn't been updated in seven years
  patch :DATA

  def install
    # GTS uses K&R function definitions, which C23 no longer supports.
    ENV.append "CFLAGS", "-std=gnu17"

    # The `configure` passes `-flat_namespace` but none of our usual patches apply.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"gtstest.c").write <<~C
      #include "gts.h"
      int main() {
        GtsRange r;
        gts_range_init(&r);

        for (int i = 0; i < 10; ++i)
          gts_range_add_value(&r, i);

        gts_range_update(&r);

        if (r.n == 10) return 0;
        return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gts").strip.split
    system ENV.cc, "gtstest.c", *flags, "-lm", "-o", "gtstest"
    system "./gtstest"
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

class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "https://gts.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"
  license "LGPL-2.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1a940ea785d016728373922b4b02ed3d40f3abf4da34cc29c671446eada28d59"
    sha256 cellar: :any,                 arm64_sequoia:  "b93bb9f091fbf2d25c99437f8ef0dc0e40f680fe445b968cf952d2d067417ebb"
    sha256 cellar: :any,                 arm64_sonoma:   "45ce1fc7fc4da58e808c6d11bd19a17c35bed97719b63e2572b22ff6bd417aac"
    sha256 cellar: :any,                 arm64_ventura:  "de8259a24624223ddab38d0e1482ec9f055ddfacc353fb0290d127919e509cf1"
    sha256 cellar: :any,                 arm64_monterey: "8bedf36ac77f7998ea926904efe011d52086e67f9901c1a64cda7e8013f7bc07"
    sha256 cellar: :any,                 arm64_big_sur:  "ed540825164e099f8f1c9719fada2d186a3f9b9ee10279ad4f2dac658bc68cb8"
    sha256 cellar: :any,                 sonoma:         "63d06518c5c1da686ecf76d612b7717bc021d8c19a6470a21ec1f69020fe1dac"
    sha256 cellar: :any,                 ventura:        "946d3f08c41e94c2861e555358fd152df7c069ad8a2a7f621b64b55cfb8ceffb"
    sha256 cellar: :any,                 monterey:       "3800de79b45b9a5736b9ecd9d48b2ab2935d74cbe57e308eeed2ddb2e07a08e1"
    sha256 cellar: :any,                 big_sur:        "486a4d3b428e12daf5573a21d60371b4cd1f9e1c7e3b14c7d2d1c0a3bea58524"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b822bc2eb7de37c9497056021cca4397053d11bfafc980820766bcdced8daff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6bb3e3859bee6f8b113a08d7d158a19ef46ec307073fac12c90c4a0113f69e"
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

class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "https://gts.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c35739e0ed8143e634eb8f0f55b892a16ced6ec9a2970eabc1f64292a5d81215"
    sha256 cellar: :any,                 arm64_monterey: "5eb4dfee13280ea9c104b3839dc42d6ace7b8f6a154c3ea1aa991aae0fc4d4a2"
    sha256 cellar: :any,                 arm64_big_sur:  "efa1e3990e707e16709bbd258502b9c248c25bb5468e8a7b3ef491c56c3a180a"
    sha256 cellar: :any,                 ventura:        "0b09f78c4fdc75e02a4036e72dc929da671249228bd67d94cbd581fd67fc5647"
    sha256 cellar: :any,                 monterey:       "7a4a3f8806004639c4006ca8b22d782cd9d9a55ee720468f7858875630882d0e"
    sha256 cellar: :any,                 big_sur:        "659f27e7e8ab695125ffe0175bf4d915f5e5618fcae0c425180fc085c3388d41"
    sha256 cellar: :any,                 catalina:       "8a0c9b4f60a2cbea2e2e3469880284c2373843e676aaf58c1ff28d1e31c2ccb9"
    sha256 cellar: :any,                 mojave:         "e0ba5b2700ba2a0c88a6345117a699c08f47738d3e727dbc64d815d1a3b7492b"
    sha256 cellar: :any,                 high_sierra:    "5aa85562ed3d0aad446825d7c4e3cc717f8044a2c638bbdcdd0e18bc0f366e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8574a923a6854116b836f04ffdd0b556d71c3e63da1127a90c2e6ac573900c88"
  end

  # We regenerate configure to avoid the `-flat_namespace` flag.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gettext"
  depends_on "glib"
  depends_on "netpbm"

  conflicts_with "pcb", because: "both install a `gts.h` header"

  # Fix for newer netpbm.
  # This software hasn't been updated in seven years
  patch :DATA

  def install
    # The `configure` passes `-flat_namespace` but none of our usual patches apply.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"gtstest.c").write <<~EOS
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
    EOS

    cflags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "gts").strip.split
    system ENV.cc, "gtstest.c", *cflags, "-lm", "-o", "gtstest"
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

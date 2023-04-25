class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.104.tar.xz"
  sha256 "22e38e1d19c5391abc8ccf936033a9d035e8a8ec7523e5cd76a4c01137d7160c"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "decf2d3420b1da9497afbc4ed04cedcdb2f02ecc21f7a570d771ed80d2691c86"
    sha256                               arm64_monterey: "8a7a0593384b7f92c9b35f7982b042280108dfda3535cc4aab45b7ea86ac42c0"
    sha256                               arm64_big_sur:  "11a1de58fad3b2cb1d13f08aaa15403b02197dfffb38aef9ca5916181849bdfd"
    sha256                               ventura:        "6b638401453355aea82785998720e5a27e67ccfae274467e1411c05060a2e981"
    sha256                               monterey:       "f94d6046b09e055a3717b605dc885e7b760e94e3dc0c07d6decb3b044953afad"
    sha256                               big_sur:        "eb7bf4458da2ce0a3a07db3885c4b66823112926636fcd24e6a7a675f1e68982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b934cc07da68f7c7812f7b015a81a9a21299a647c51493d9df1e2534955ddf"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dwith-docs=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"

    system Formula["gobject-introspection"].opt_bin/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end

class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.100.tar.xz"
  sha256 "a5e6e193676215d65d7cdfeaf1158a060b42a142a36f1ab076d1833212f9d2d4"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "ec28930e1eaff7a52959fe9e14dbc493da41cedff4c4a3ac6532685722c13f38"
    sha256                               arm64_monterey: "5f334080ec288a84258cdcd1b69c8bb287dff718011cdafca075308f3b53fe6f"
    sha256                               arm64_big_sur:  "24240a100f9f4c23f4a02747e618b6092d044e54fb7bc2439613aa97d02b48a2"
    sha256                               ventura:        "74bbb9d876a09bb994e2600ae4cd46628d1dfbaf4cb1ce8878eac4cf147effd7"
    sha256                               monterey:       "363334a6b72fcf78c5381d061254239105b35b8e88213db5ea16b67f212ffde5"
    sha256                               big_sur:        "121d78f34e0b6c400988a3a2e2ddc50dd9db14d0d2c97832d88b7b227bec375d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1018eb7224cdc4b96dda18e3e5b9262dc711c50a5c9c533f5210a0e7503d7238"
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

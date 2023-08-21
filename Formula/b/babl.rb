class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.106.tar.xz"
  sha256 "d325135d3304f088c134cc620013acf035de2e5d125a50a2d91054e7377c415f"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "d2262c448da0fbd1483282bf7978d537381608d10e98778a6a7e3dfb332b797b"
    sha256                               arm64_monterey: "1a436ea903c5eeb2cdfa524171c8976ac0047ea0fc48c3daacc8f814f367b723"
    sha256                               arm64_big_sur:  "fe7ce007039e7d52fb050c0581b179c339f2dbec696d84a584c30a39bc2490e5"
    sha256                               ventura:        "86ad27203bd7e18d035a1c1f089fdfe336e5ae4fef112615b6961a225cf12e03"
    sha256                               monterey:       "cc27752609a03322409dea058eb438cd198a785fbbc541e31b08cc671d73bd97"
    sha256                               big_sur:        "3aae805b1aee8eb7462a31e95db66c0d2e1b2cd9fdbecf06ac947f32ac57e74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324b6d7f0de8ab3568a9f3ce0a3197199c2a098ea1abbee970d471de866b30b1"
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

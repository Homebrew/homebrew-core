class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.116.tar.xz"
  sha256 "50fae069867c7ade1259888ff1e3db85fec86d708252e5385b5a4f39a78ec483"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "85c839537f9471af091c716deff006d3c533a179fdff40fa2a191d257f72afa8"
    sha256 arm64_sequoia: "d9811006ba4c60cbfa2d3cb23c85b2446a6f8c3b8e3a291b677cd2a1f82e47b8"
    sha256 arm64_sonoma:  "ca8508bda2750d69d76d513be77360f6b15981969dc9526d9454954e5dbf5f54"
    sha256 sonoma:        "bbdbf27e0c0b4eb55b0f3a8c9d8287d64e836c1482358e7349e15ad1c82c12d6"
    sha256 arm64_linux:   "08bf951f290b244cb91e6b3f871d2976809c17e76da10b7cb2b1b13fd1d84907"
    sha256 x86_64_linux:  "864d00c576fa0df3f7b2a80d3fdcfa1f2fb252f04c36d4260b95915b25467747"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  uses_from_macos "libffi" => :build # to add to PKG_CONFIG_PATH for glib

  on_linux do
    depends_on "util-linux" => :build # to add to PKG_CONFIG_PATH for glib
  end

  def install
    system "meson", "setup", "build", "-Dwith-docs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    C
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"

    system Formula["gobject-introspection"].opt_bin/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end

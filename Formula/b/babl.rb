class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.128.tar.xz"
  sha256 "e676507b421d414d49db8627415dc1eadbd787536baa7d6fe94a1f1971cbe73e"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "62a48f99e10375c85a21c6d8cac6522e3d69969f7aaeaa287f053666b6d044bd"
    sha256 arm64_sequoia: "b31e9c8879397ac0b7d852678272a5f12806d1aca99e71cae4d728b46b84eab6"
    sha256 arm64_sonoma:  "1006f4dd3f5b9e19da214bfc604af6006065037da39256a9cc90bf45a7b2b903"
    sha256 sonoma:        "f32536e8bb1b2db0fc9522252ca1187f148964b8ae9460bba2a55fa1ca574893"
    sha256 arm64_linux:   "74b3531bd9da3d27ae4fb0177803635508f60654bec64638a31792bb2c97c0d1"
    sha256 x86_64_linux:  "2a3b46660626a3fa045698091d52ebf8b4633a59e8058b5b231f9561d1a38612"
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

    system formula_opt_bin("gobject-introspection")/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end

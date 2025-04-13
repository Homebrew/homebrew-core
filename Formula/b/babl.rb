class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.112.tar.xz"
  sha256 "fb696682421787c8fecc83e8aab48121dec8ee38d119b65291cfcbe315028a79"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a58f2a505e49069e5296b46d6aa8bee3e5761b74f044a96f44e262000cba9c32"
    sha256 arm64_sonoma:  "333e8751c49a04a3bc4e5772f352bc7c8fe743dc34dc9df2f78e4dbb4bb518d3"
    sha256 arm64_ventura: "f14266a96e73d8adca2f443b9a2772bd9f6dc8bc36d9a8ac6dc6457a2979622b"
    sha256 sonoma:        "3bf47b936a8167c8cc60c0e5c3fcef99a740bb6e55378d509acf43fe8798339e"
    sha256 ventura:       "ed297904acf6419d5b230c5902a07f6571f623d28089f8f6249aea0de47cafd9"
    sha256 arm64_linux:   "1017308313da3b6cf79d37943b152f1ba94e3778f22447842cf201a83e1a2abd"
    sha256 x86_64_linux:  "d59490c60c6f01018183a4bab2a42a5d95a1da63cb8b467a48b40e60cfc88f31"
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

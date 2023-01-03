class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.98.tar.xz"
  sha256 "f3b222f84e462735de63fa9c3651942f2b78fd314c73a22e05ff7c73afd23af1"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "84568f1aef9f12ea0b0a17985cdcd48d7b592882b1cbe1242b37b54211e4469f"
    sha256                               arm64_monterey: "d2db35d55cad4608af300198c59743726ea50e179de77d7d7d9786dc85a49dec"
    sha256                               arm64_big_sur:  "926919275642427848e680b805cc2e0d8ae13aae618d2a9daa5be9f6b2be265c"
    sha256                               ventura:        "0b6056b98919e2ba5302a3679bc7e38d991ec53a37d300b344410f563fa8f4e9"
    sha256                               monterey:       "5a0c71b38f144754e54ef692fcf3e93aaecd5cdc2d1dc1b90ef5045f39d71182"
    sha256                               big_sur:        "4aa16bf88b8c731c37a96d56ef60ceb1a754a31f563e857618bc18e72a825176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a74b8ead443e96eaea886db4d376261d15d43eaa2da1b1c099a3badaabf6c3"
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

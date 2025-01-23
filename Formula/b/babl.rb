class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.110.tar.xz"
  sha256 "bf47be7540d6275389f66431ef03064df5376315e243d0bab448c6aa713f5743"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia: "147cea64ffccae5da20c8e6896db601e3c12fe1df5f6f5c2580a746af348be4e"
    sha256                               arm64_sonoma:  "2c4f97f6ea0da560095f5d93285b47e00c37edadadffd133679662a15232a854"
    sha256                               arm64_ventura: "6e624a1cfb00d2718c1da20e8f64a40356fa5248d5c343458b58c11c20d4e28b"
    sha256                               sonoma:        "6cf45b37cb88356d1f68d5047fe351ebee46150ed9003b8f2fc6308e67c9a7c3"
    sha256                               ventura:       "6b340ce32c9b0095fddf0d5ea61d9c1bdca667e3610f74110eb6491d00ab6aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3179d3e7472775e90a8befb85f6d611a68f0860c60e1386ea868686a89b443b2"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

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

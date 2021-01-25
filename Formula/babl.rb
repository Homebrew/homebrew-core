class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.84.tar.xz"
  sha256 "e7e38b8441f77feb9dc8231cb434a86190a21f2f3692c281457e99d35e9c34ea"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "2cf2c6915f2d08e32469348694eca72ad8fb994d7c8aa8fff02f8cb5e46d4216" => :big_sur
    sha256 "799c80b4b2e5cbefa44a2e8113d9a910a74f4d5a729e4792f1514dcd6bd77763" => :arm64_big_sur
    sha256 "0529257e189f0f9db5b2def58ae19e3097b5845147b49e74f5baec9a39b18e11" => :catalina
    sha256 "f28c8bd67641d91920281e7f7774ddf9c34fb97f341f689efab4858cb858c9ab" => :mojave
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-docs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
    system ENV.cc, "-I#{include}/babl-0.1", "-L#{lib}", "-lbabl-0.1", testpath/"test.c", "-o", "test"
    system testpath/"test"
  end
end

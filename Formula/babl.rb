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
    sha256 "1084eeed2d6050173dbeb2e51ec2ad18317c7d96961415186565b3741c0ffb32" => :big_sur
    sha256 "b93e792558079590119f8b2200dd7a961bfc7c85b44f0673f246a207cb85b234" => :catalina
    sha256 "9779cd6af6abb889b8f23be1ddbe32b557cb99771fe4c7c03c80b23ad7c44235" => :mojave
    sha256 "578ce9f5ab5ceb114dbdb2c03279b7a5d4521783173a967443dfb21979e1cc96" => :high_sierra
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

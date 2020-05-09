class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.74.tar.xz"
  sha256 "9a710b6950da37ada94cd9e2046cbce26de12473da32a7b79b7d1432fc66ce0e"
  revision 2
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "f496c852dae8483303d4ee8181e2890d6142fa0c12d521fb9aa8a07876ea5773" => :catalina
    sha256 "74cb9aafa1e5921b32273d2292ad8f0abc21b514f68369cc1695f41b675c8fde" => :mojave
    sha256 "41c86544c0ec200a57379e9e9a9fdbbf1bb58c3782c647c83f8cb8d4bf865ded" => :high_sierra
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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

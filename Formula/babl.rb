class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.74.tar.xz"
  sha256 "9a710b6950da37ada94cd9e2046cbce26de12473da32a7b79b7d1432fc66ce0e"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "2ef985cee9f141135a50598a283ed465798ffb0385c515a30dab0c25a27dc4c8" => :catalina
    sha256 "55b7746f0c997a0833ff8fec9d892ac6b81382b1c5d7d80f9c939b4b2f27e733" => :mojave
    sha256 "460bca8dc9a0dbe38e7c659d746a0b3c0df80237c0dfc8884d8750bad75729d9" => :high_sierra
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
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

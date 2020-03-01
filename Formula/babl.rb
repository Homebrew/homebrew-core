class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.74.tar.xz"
  sha256 "9a710b6950da37ada94cd9e2046cbce26de12473da32a7b79b7d1432fc66ce0e"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "e00f9ef31c286109f9f6cbbfb819876306e40c67380338c684b3c63759a94c94" => :catalina
    sha256 "298f41a91ed4b93bbc29254f40691537ffd14bee7322d862b1b96f5996cfd865" => :mojave
    sha256 "0d8bf0f5aea427b7d9ca8b05cdf49b0a2bce4c3f41b9d148f42103e2454de667" => :high_sierra
    sha256 "3cd4d6d3cc86dc1bc2b8411bf4ffb911df58458d54fc938730fdede11587c624" => :sierra
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "little-cms2"

  def install
    args = %W[
      --prefix=#{prefix}
      -Dwith-docs=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
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

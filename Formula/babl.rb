class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.72.tar.xz"
  sha256 "64e111097b1fa22f6c9bf044e341a9cd9ee1372c5acfa0b452e7a86fb37c6a42"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "e00f9ef31c286109f9f6cbbfb819876306e40c67380338c684b3c63759a94c94" => :catalina
    sha256 "298f41a91ed4b93bbc29254f40691537ffd14bee7322d862b1b96f5996cfd865" => :mojave
    sha256 "0d8bf0f5aea427b7d9ca8b05cdf49b0a2bce4c3f41b9d148f42103e2454de667" => :high_sierra
    sha256 "3cd4d6d3cc86dc1bc2b8411bf4ffb911df58458d54fc938730fdede11587c624" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "little-cms2"

  patch do
    url "https://gitlab.gnome.org/GNOME/babl/commit/a04535b0964d2bd40d08e4b3d16ff27b6ee7262c.diff"
    sha256 "8611e53e8d51207942ea54e8fc7a5773019ffd08ba188cead08fb18457e95789"
  end

  def install
    system "meson", "build", "--prefix=#{prefix}"
    cd "build" do
      system "ninja"
      system "ninja", "install"
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

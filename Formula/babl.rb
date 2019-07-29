class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.68.tar.xz"
  sha256 "412dc8356b1e200e0f3aaa41bc6c317b9e489936c17c4e92cc5db9d34ca1e94c"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "298f41a91ed4b93bbc29254f40691537ffd14bee7322d862b1b96f5996cfd865" => :mojave
    sha256 "0d8bf0f5aea427b7d9ca8b05cdf49b0a2bce4c3f41b9d148f42103e2454de667" => :high_sierra
    sha256 "3cd4d6d3cc86dc1bc2b8411bf4ffb911df58458d54fc938730fdede11587c624" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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

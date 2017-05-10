class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.26.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.26.orig.tar.bz2"
  sha256 "fd80e165f1534c64457a8cce7a8aa90559ab28ecd32beb9e3948c5b8cd373d34"

  bottle do
    sha256 "59dbdde4e0b9163f0ea4454633081afd6857ba4a41210c1b2d5220645396b783" => :sierra
    sha256 "c57ea02e61a81516ae316b306676f4c81c4f1f894fcd888d69331eea2e1f498a" => :el_capitan
    sha256 "49ed1ceef9c136ddbe1ad1dfc8a3fcc5d8aa2262fdfaa39d20e055e20201b6e3" => :yosemite
  end

  head do
    # Use Github instead of GNOME's git. The latter is unreliable.
    url "https://github.com/GNOME/babl.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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

class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.38.tar.bz2"
  sha256 "a0f9284fcade0377d5227f73f3bf0c4fb6f1aeee2af3a7d335a90081bf5fee86"

  bottle do
    sha256 "66997f2a167fe9594ab9141d70984910cb1dd187dee918cc9621c4f902658593" => :high_sierra
    sha256 "6de97dad3dd478fb8d1ad7a676cdd2ea366472dd534b82938868bbaf9fe0663f" => :sierra
    sha256 "40016d19840d222124fa86700b29572cbb39ec276eb09b85ebf2d1cfc75ac753" => :el_capitan
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

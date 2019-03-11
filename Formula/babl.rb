class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.62.tar.bz2"
  sha256 "dc279f174edbcb08821cf37e4ab0bc02e6949369b00b150c759a6c24bfd3f510"

  bottle do
    sha256 "fbf1c53fbd31c3a87831f475432c1f4bc3877ae1e99fc52429e149cfe5d3a30a" => :mojave
    sha256 "3ff90de90576f944a3db0cb6d85ad11dbf3bb8ea719e96e09fad95bf57a5d390" => :high_sierra
    sha256 "bc3595575986794340bc7d772cce69f91a419b868ea46f8a59593dd565e2e92b" => :sierra
  end

  head do
    # Use Github instead of GNOME's git. The latter is unreliable.
    url "https://github.com/GNOME/babl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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

class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.48.tar.bz2"
  sha256 "be9bd05cf55c8e46609ac1a30b1f63fe3917e0d7643c4d8d2798b68f3f752615"

  bottle do
    sha256 "457cbe515cc1cbf7b4a27306a4576002db363d148c033cf81a36db63b2a81f9a" => :high_sierra
    sha256 "21fec381f4664d9b0b266627eab2f22224959f68dbe461d5341194a7d09a71ba" => :sierra
    sha256 "cbdcc371a817a945c76b44449cae73a488119176c35903ff9d4480742bc83484" => :el_capitan
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

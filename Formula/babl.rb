class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.44.tar.bz2"
  sha256 "f463fda0dec534c442234d1c374ea5d19abe0da942e11c9c5092dcc6b30cde7d"

  bottle do
    sha256 "73c468fb9fd53012a6f611f154197a7c4a1818ee018975e80e93c32d0021711c" => :high_sierra
    sha256 "7d6ec0effa8a598cd74f9626847f81b428c9da28a1b08b3f0a5f5793626b15d6" => :sierra
    sha256 "739f3f0cb627c1d91dcadf1fda141afa5721aeaa410311246cdd358a0d6849e5" => :el_capitan
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

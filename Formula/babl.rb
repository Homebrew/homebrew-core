class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.30.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.30.orig.tar.bz2"
  sha256 "45c12c7b06d965123756821fc70c968137d16d44151a6eb55075f904e11d53cc"

  bottle do
    sha256 "3ce0980b598b09cd523b6e224a6a9fb8997153d3bd9f9aa2d7f2c5c1cc1fa126" => :sierra
    sha256 "14c733c7c04a834f18ffe550ec744d573cf68fa0d955aa2107c9e823407b4ce2" => :el_capitan
    sha256 "1633483a612b35b96e7317af2be2de9c7dec0d0c2b6abac992b41dd29bbc5adf" => :yosemite
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

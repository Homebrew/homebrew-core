class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.30.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.30.orig.tar.bz2"
  sha256 "45c12c7b06d965123756821fc70c968137d16d44151a6eb55075f904e11d53cc"

  bottle do
    sha256 "8d0aafb0aaa6c3f486f5160ec4aa6224ed0b55c029220ce5c0b95a0b1e958a97" => :sierra
    sha256 "5c3f7f3f2a1ac3ea65c4bed72cd449e7e3085762016df55c0fbf46ae106aadfe" => :el_capitan
    sha256 "9d6dbd5fb423e321944c64476cd4758b7f24431e7df4c9bba507b416373109aa" => :yosemite
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

class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.54.tar.bz2"
  sha256 "4d2bf1345d7214b08762e6d1e23d0038508b806dbf7c4c44386faee434682a07"

  bottle do
    sha256 "d73e6f23f59fc5eee59db696ff94ae05dcf7eb0ad474de3324b13fc2ad902430" => :high_sierra
    sha256 "a6b4edbbceafe298aa246a8caa0b4bcf63816402c2bca393c820e92a79957723" => :sierra
    sha256 "352c463a9431acae25bd294d0773f5c0721cab64d271180d3775f72287d38da6" => :el_capitan
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

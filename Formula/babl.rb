class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.54.tar.bz2"
  sha256 "4d2bf1345d7214b08762e6d1e23d0038508b806dbf7c4c44386faee434682a07"

  bottle do
    sha256 "2386ff1497ac92218cca9f5dfa7533a2a0bc0015753cc2fe4bc7ab711acd1280" => :high_sierra
    sha256 "a6be1257424172567d5ca8a9c455b8e9a1d44159736b61a846e994bae26461bb" => :sierra
    sha256 "18bc6c586decd6a7e45d5266c2b3653322a9ca50e5577dd7b9b8f446f310bcd5" => :el_capitan
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

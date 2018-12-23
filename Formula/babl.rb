class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.60.tar.bz2"
  sha256 "a3d1eeccb6057ccbc189dc926ebaca96cd4896f3391f857b86334d2245f0604f"

  bottle do
    sha256 "efb6b0840251a3ea273d8676b519140ddfe06532236012cf64c64d55d9dbfa98" => :mojave
    sha256 "3daf384bb830c95c6eda08a3010ebb0052bc501740f722ac3cf03db35c0e34f4" => :high_sierra
    sha256 "0c67ab09a6858974a62fad5ef8272c04264b0d520002880b8d03c04350bb4e9c" => :sierra
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

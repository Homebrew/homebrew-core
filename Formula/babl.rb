class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.48.tar.bz2"
  sha256 "be9bd05cf55c8e46609ac1a30b1f63fe3917e0d7643c4d8d2798b68f3f752615"

  bottle do
    sha256 "034c02a1217630714895a922440e0e513f9c07d43c85b797fa40befbdffadf39" => :high_sierra
    sha256 "07bc7a1562c9449b1dc78d7e00fdf0c83531fd6aa739f162f043075de4fec0eb" => :sierra
    sha256 "16039f7daedeb5a64173422111829d0f0d9461e1f6e74691a6a9c0d64daa5c9a" => :el_capitan
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

class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.36.tar.bz2"
  sha256 "97f0eb01eb6760cb20a4deca0096aceaa77c6d7a88a375c2b872ca1ef3ae29ef"

  bottle do
    sha256 "485a493419f46bc32a31f7506eaa40b689ed6301d74cd139806f7b9c5662ed07" => :high_sierra
    sha256 "9c25fa7bc86e773a6466d959653834bfcc2435b17149e5f7a973adc8c0db9075" => :sierra
    sha256 "36a4b1036d745ac25cf58deed53d7f3b6408c7a147facc18f3f08bd711ceaf82" => :el_capitan
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

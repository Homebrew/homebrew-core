class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.50.tar.bz2"
  sha256 "b52c1dc081ff9ae8bc4cb7cdb959c762ea692b9f4431bacf8d17a14dbcc85b2d"

  bottle do
    sha256 "f86360c2f51a55641cc92089cf5b8fd053017be3a502fe6d19a1cb7f47b6579a" => :high_sierra
    sha256 "b68849e1cb083b3a8305b2c62f75194f1c9acd9673e6f052bf7b1f8fab38c604" => :sierra
    sha256 "31aaf11755c354b4af9e06bfdf4791de7f89eafcc63715dfb093daeceb617c50" => :el_capitan
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

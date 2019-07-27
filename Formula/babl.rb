class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.68.tar.xz"
  sha256 "412dc8356b1e200e0f3aaa41bc6c317b9e489936c17c4e92cc5db9d34ca1e94c"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "c31ce72d90cf85ffc1391edfe53cb7675c3b96de966d3e36ac02f435640dbf8d" => :mojave
    sha256 "e000115b46eb286890c56080b429cf80a04c25e6a3462f66863e4f011a163cd6" => :high_sierra
    sha256 "1e21ec92d5d7afc3d096929271a393b1d39fd68e6f582e004802afce6ba5f07b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
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

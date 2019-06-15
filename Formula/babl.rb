class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.66.tar.bz2"
  sha256 "369dd89345489a3949e83d5ad63295029088230626f64a05e530761b176fa163"

  bottle do
    sha256 "c31ce72d90cf85ffc1391edfe53cb7675c3b96de966d3e36ac02f435640dbf8d" => :mojave
    sha256 "e000115b46eb286890c56080b429cf80a04c25e6a3462f66863e4f011a163cd6" => :high_sierra
    sha256 "1e21ec92d5d7afc3d096929271a393b1d39fd68e6f582e004802afce6ba5f07b" => :sierra
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

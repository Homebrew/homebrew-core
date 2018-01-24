class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.42.tar.bz2"
  sha256 "6859aff3d7210d1f0173297796da4581323ef61e6f0c1e1c8f0ebb95a47787f1"

  bottle do
    sha256 "aa6da37114ec9fc56d84c9b1fb24346f8fc04465a93f6010f88fb9babe8e094f" => :high_sierra
    sha256 "5510f5c2d983158497c0b84d3ad30d1236a2d1835c2ecf6535002a2c0ff41253" => :sierra
    sha256 "a7abc27416dc61fad3fb91d65b77d455306e99090ea82816944c0ce115f9921b" => :el_capitan
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

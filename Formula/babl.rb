class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.42.tar.bz2"
  sha256 "6859aff3d7210d1f0173297796da4581323ef61e6f0c1e1c8f0ebb95a47787f1"

  bottle do
    sha256 "eb92691ca1eb028ec22a81dc7c651ac775df3a28f009d9269d4b127e6ae2e4f2" => :high_sierra
    sha256 "e0fd28fc57304bb99b4e314750ccf7e53b867ae197a2f89fee663c92fc0bbf99" => :sierra
    sha256 "22e7a45f84ba983ea2e21648b5c92ff429101a8035a2626f19f6099503c18cc7" => :el_capitan
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

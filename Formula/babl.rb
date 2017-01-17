class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.22.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.22.orig.tar.bz2"
  sha256 "f38a02e76fb96f4119ca82b4088c23f9183b9601cae19c1d8147e3ee8eaf2cca"

  bottle do
    sha256 "641f5989d5ccdf216fa8eccec71097812009b3b348c349d000870753690b1b57" => :sierra
    sha256 "04afc4671fc506ca75901d96ba1d936bc215d690532cd652c796a79726e9b219" => :el_capitan
    sha256 "5198b6334914e82215804675086f5181b285389cd1a7a5af0575488499dd4364" => :yosemite
  end

  head do
    # Use Github instead of GNOME's git. The latter is unreliable.
    url "https://github.com/GNOME/babl.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build

  if build.universal?
    fails_with :gcc_4_0
    fails_with :gcc
    ("4.3".."5.1").each do |n|
      fails_with :gcc => n
    end
  end

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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

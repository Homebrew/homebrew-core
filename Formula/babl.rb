class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.20.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.20.orig.tar.bz2"
  sha256 "0010909979d4f025d734944722c76eb49e61e412608dbbe4f00857bc8cf59314"

  bottle do
    sha256 "7a51aaeb117914278e3b6774040b3d2a8f00a84ab2b715ace6a98291e1239aa7" => :sierra
    sha256 "92734ee3bbac21f60fd8973ee0e3efe674c4a2ae7bf91d63a51ddfb9ff0498ab" => :el_capitan
    sha256 "22fd24a706ddc5764c77462541895f01850d1db18424b190a24e477e81066570" => :yosemite
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

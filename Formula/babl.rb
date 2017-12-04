class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.38.tar.bz2"
  sha256 "a0f9284fcade0377d5227f73f3bf0c4fb6f1aeee2af3a7d335a90081bf5fee86"

  bottle do
    sha256 "9251bcc6bf3aae8125734b09a3fe12d99dfb6c0b575f791a40053d24affd142e" => :high_sierra
    sha256 "0bf2f89a6c19096660b35ce4f95f2dd3c94a7dc4605f2f2292e01d5d78a49f5e" => :sierra
    sha256 "4fb1fa44bc48b449a25c9fe5bc7529e8135a7c99bb6896c203a3a49530c989ce" => :el_capitan
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

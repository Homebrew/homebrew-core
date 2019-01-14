class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.20/libgphoto2-2.5.20.tar.bz2"
  sha256 "e10ff0140e2e5dddaf6c6d9d933ab6f8c0bc66fdf7445b1ef2ca9f4d96e68b0f"

  bottle do
    sha256 "6144f7bc9116e9e0b9f212ddfccdaa1e6d41d81115af9d95d472a33a991a6da2" => :mojave
    sha256 "e9a0a109454b659c967785dc5f2486bd9afd38b148d5c53f9c2de14819adc937" => :high_sierra
    sha256 "204757c640e67a076307af01810a5315d3bc21e2f57722e62992ac64ee122488" => :sierra
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgphoto2", "-o", "test"
    system "./test"
  end
end

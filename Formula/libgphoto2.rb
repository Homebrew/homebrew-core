class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.14/libgphoto2-2.5.14.tar.bz2"
  sha256 "d3ce70686fb87d6791b9adcbb6e5693bfbe1cfef9661c23c75eb8a699ec4e274"
  revision 1

  bottle do
    sha256 "895b3f2dc366053a23eb650670178ba2294dfc174859176f875e4418af75e25e" => :sierra
    sha256 "5557755308da9bc318d10e1dd8ec41e3299fe65026fa60319a54a8d8e340e9a6" => :el_capitan
    sha256 "483f85ccf47b1628cb898a1a00380c54491abcfeccc7d3bf5c25a8deb66a54f6" => :yosemite
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"
  depends_on "gd"
  depends_on "libexif" => :optional

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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

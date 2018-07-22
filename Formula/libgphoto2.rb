class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.19/libgphoto2-2.5.19.tar.bz2"
  sha256 "62523e52e3b8542301e072635b518387f2bd0948347775cf10cb2da9a6612c63"

  bottle do
    sha256 "88f6b7614c1278de80aa5e72124cfe8d30bda5d8f5470e0d5bf299ca8f4da718" => :high_sierra
    sha256 "824d1619a67129548fa8e72abfec44209d9724629b0d78eedebfc607524843af" => :sierra
    sha256 "f5592982d36ed61b075cc203bf1ceeacd83aaaa64bc11781b22b45ec02f47371" => :el_capitan
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
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

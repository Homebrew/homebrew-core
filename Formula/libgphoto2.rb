class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.15/libgphoto2-2.5.15.tar.bz2"
  sha256 "b5f87bed3b53eaa610620f792e44c48193585ec68f902b8e6b2e8ca3205a7d61"

  bottle do
    sha256 "950a832877636dd798debccfa54851b20d789b995af9fac3d188a9ef245fec81" => :high_sierra
    sha256 "59aad97b5b53afba7927e19a202c463e09d4ed02c0f82bfe56b5d83dc9e8a7d4" => :sierra
    sha256 "657209639d246f5c1e16429f8636804188bceb6fe4f9d0616ea75641f6b92488" => :el_capitan
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

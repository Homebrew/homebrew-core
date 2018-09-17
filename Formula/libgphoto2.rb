class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.19/libgphoto2-2.5.19.tar.bz2"
  sha256 "62523e52e3b8542301e072635b518387f2bd0948347775cf10cb2da9a6612c63"

  bottle do
    sha256 "5cea8f07629664424ffd28806d8bec974c1a30debaa630568254edda97e6b469" => :mojave
    sha256 "f65f60da6f1493be05fd58fb66126056d8ba81eca4d4c56d752cd3a9601b5b5c" => :high_sierra
    sha256 "dbba065cb5cdf62a30dcf31f04524b0f2a99d3c28290f7d77523c0fcfbf92314" => :sierra
    sha256 "e11334f3d377befc92347c9c073ad43c82a8de1b57d7749411affb7333ff77a4" => :el_capitan
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

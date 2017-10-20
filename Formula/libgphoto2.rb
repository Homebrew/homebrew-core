class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.16/libgphoto2-2.5.16.tar.bz2"
  sha256 "e757416d1623e01a9d0d294b2e790162e434c0964f50d3b7ff1a3424b62a2906"

  bottle do
    sha256 "42d67ebe5a33c3a41237fcaae5f5f89827a93e4b01da6f37becd8f59bda3d3b2" => :high_sierra
    sha256 "f775f6c15a087e09939cf4f4514db5a3019e57cff0c16f19de8cab04a56a06d4" => :sierra
    sha256 "4990ce77089bdb05581b0cd72fde5851a4e19df9916a46c298c50e49c6d83543" => :el_capitan
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

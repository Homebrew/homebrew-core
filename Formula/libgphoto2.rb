class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.17/libgphoto2-2.5.17.tar.bz2"
  sha256 "417464f0a313fa937e8a71cdf18a371cf01e750830195cd63ae31da0d092b555"

  bottle do
    sha256 "4f0c7d9db9b92b9f2a7a1795d7784fea5864617265e40c5204d240239a44ad40" => :high_sierra
    sha256 "c5eacd1a597b2f03ba62c581dee96492a3fba10672cf7b9472cd2e06837f61fe" => :sierra
    sha256 "69d3c58c841174c4bde3e1068fbb4adaa3bdf81a69c82fd1177cb71f49cf9482" => :el_capitan
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

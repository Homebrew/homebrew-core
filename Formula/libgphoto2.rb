class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.10/libgphoto2-2.5.10.tar.bz2"
  sha256 "8d8668d432ba595c7466442aec2cf553bdf8782ec171291dbc65717c633a4ef2"

  bottle do
    sha256 "e2d8ad91607270b43671899448beb926b98e639f4a61892eb2756743a5d74d0e" => :el_capitan
    sha256 "7ffab7c5114e341807a93656bca4909dba424ed847ebb939be5d1eb46bdeb6eb" => :yosemite
    sha256 "2e444b4547330228c78e30112692d79d54f3786c99a015328ba9b039dfcc79c2" => :mavericks
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"
  depends_on "gd"
  depends_on "libexif" => :optional

  def install
    ENV.universal_binary if build.universal?

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
    system ENV.cc, "test.c", "-lgphoto2", "-o", "test"
    system "./test"
  end
end

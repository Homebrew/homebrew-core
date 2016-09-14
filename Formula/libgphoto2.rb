class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.10/libgphoto2-2.5.10.tar.bz2"
  sha256 "8d8668d432ba595c7466442aec2cf553bdf8782ec171291dbc65717c633a4ef2"

  bottle do
    sha256 "ed0718274ed1e0508312756349688aef28ff0d0c4f130f77d704b66110334f47" => :sierra
    sha256 "576dc15066fd0a849abac37194d820d4c61c90e00341050e239efa0d81e1be0f" => :el_capitan
    sha256 "d8bf8c3b22dfe3c1443556a6f2a4858038ecc9b37e64c7f99df4697b38927f4e" => :yosemite
    sha256 "ede9214875529506ee8a3537c14a5fa4685c90628d8a8241172f61cad3f48f99" => :mavericks
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

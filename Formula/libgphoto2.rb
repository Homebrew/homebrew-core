class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.13/libgphoto2-2.5.13.tar.bz2"
  sha256 "ceaacbdf187d1cd1aed5336991f46b0100f6960b6c8383f9aeab98f1f64780ef"

  bottle do
    sha256 "efa089e19934b093ecc00a85d3d73c8930f7c17f7ecf25aff80a0aa8b8b2f9af" => :sierra
    sha256 "80f6ae00572862d4b3ccedbd6c2061176ba8289a1efa25961738dd59e67dc55f" => :el_capitan
    sha256 "6e5f714b120204039ffdb622a6a98cb8ec3a3ae6b9310fb59259be3d2fed2213" => :yosemite
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
    system ENV.cc, "test.c", "-lgphoto2", "-o", "test"
    system "./test"
  end
end

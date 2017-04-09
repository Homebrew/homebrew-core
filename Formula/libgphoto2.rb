class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.13/libgphoto2-2.5.13.tar.bz2"
  sha256 "ceaacbdf187d1cd1aed5336991f46b0100f6960b6c8383f9aeab98f1f64780ef"

  bottle do
    sha256 "fe4981c740e836964c904e902f4ed6f574eaa592cbcb2b7c09f7494bb7f3623b" => :sierra
    sha256 "76437bdcca172b21d77b157618c7e0b84112429bcfd94f211da3e5fcbf8d50aa" => :el_capitan
    sha256 "c8be602b47dbd2423d8b9ccbc7dc5c583d6006a6d52203d612a6d800bd190e31" => :yosemite
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

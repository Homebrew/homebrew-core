class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.12/libgphoto2-2.5.12.tar.bz2"
  sha256 "b9bb28990fde45ac385e4851a07dbad2e1250404b535b0a3a3b898bb431e4e2e"

  bottle do
    sha256 "f66faa2958b535af43c2891e75f39116cc798b3c2bdb6137f4990997fb944d74" => :sierra
    sha256 "a49a7d8071c17b5f817589d684b87bb0b5bf9a7e5ab6bc3b4a5f31f40193be94" => :el_capitan
    sha256 "0b690cde244e88750786ba8ac5aad3a44dc431f73800b7d0627fd1a10132789a" => :yosemite
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

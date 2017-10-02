class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.15/libgphoto2-2.5.15.tar.bz2"
  sha256 "b5f87bed3b53eaa610620f792e44c48193585ec68f902b8e6b2e8ca3205a7d61"

  bottle do
    sha256 "b66f9400fdfc6758688a7b04045b866513f9e8866f36f8c56e1c06b708a1289a" => :high_sierra
    sha256 "9212fdc127bfa4d4075045d45c197640cd240e8c3f0eda1659ce01b992c12c2e" => :sierra
    sha256 "560f19e1f478e4893a79ffa5c0337cb51956060c3b3d394e17c972a7d2d7681e" => :el_capitan
    sha256 "888bc3cd95c7637c5f333e9e1f2a3ef021a171a6d19997409d470f704950fc9c" => :yosemite
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

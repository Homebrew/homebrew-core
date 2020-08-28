class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.25/libgphoto2-2.5.25.tar.bz2"
  sha256 "7c0e98f438c2b128186afe16ce7833a12fa36f87d01467e837b9d27e7a167f3a"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "0609b72a67e2d6c45ede30bb4cfca8b4fc6b312d5873c4e647e292fdc1f227ff" => :catalina
    sha256 "5a1f7ec7d0146bb772a4c6fa2ef5ed53e6a6ac183fe1f916ca8b53b2a4c68ad9" => :mojave
    sha256 "110b4ca7ee321419851bcf5b8401d2fe082bf29261787700890f93db77af0112" => :high_sierra
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

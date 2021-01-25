class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.26/libgphoto2-2.5.26.tar.bz2"
  sha256 "7740fea3cbb78489071cdfec06c07fab528e69e27ac82734eae6a73eaeeabcd4"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "d622d90aec3ddb4e168eda447ff0841c318b701710906290636ba24d4b9d7b60" => :big_sur
    sha256 "2215d38a580f2d8e80bbcdfc6eb0a6b84db905e33db309fc8225fd73cf2cf480" => :arm64_big_sur
    sha256 "9ab56abc466d07fdb2d16aced13ae7afffb9e71642b8c86a0b1610304e34baba" => :catalina
    sha256 "434336b976e6c930255891e9d478fec925c484f50fdf153dca262a9184b6874b" => :mojave
    sha256 "918032eba6577fda5b956841d50abd91c5272a0d1b69d21f3ac9f40eb24027af" => :high_sierra
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

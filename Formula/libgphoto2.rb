class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.29/libgphoto2-2.5.29.tar.bz2"
  sha256 "dbe3cefad8c634fc134d93467a33e242cb1030f0b9829deb9f1703f368ac027e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "6c80831d84e3ab5b262ab6b7efa2732af36aa92a88e7e0a63d0a37535d2161ef"
    sha256 arm64_big_sur:  "0e79ac4d1a57cee1f3008f0eab644c6c2f451fd7a2ea67053d2cd4a14763ec55"
    sha256 monterey:       "af7f3362d28e36f23256e99b3205fe6ac469afbfd47fa75862729e6d3c8ca771"
    sha256 big_sur:        "6a613d9f83b3f272294448b9b07152537bd5a66390972cb4deaadffc28e5fa45"
    sha256 catalina:       "988a6f660584ae3395ee839533614a869c6177c931791cf074db133e3c0c57e0"
    sha256 x86_64_linux:   "206f9db7933f05ac5ddffe94e58009268968e58702d406a94b6f1dc200b95c71"
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

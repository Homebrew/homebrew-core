class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.31/libgphoto2-2.5.31.tar.bz2"
  sha256 "4f81c34c0b812bee67afd5f144940fbcbe01a2055586a6a1fa2d0626024a545b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "3fb2e9bda06e7f94540e798c31fca1f06d8028039eb2e558e501e4e85e68402f"
    sha256 arm64_sonoma:   "a755497f42fd0a62182de3d1ba2956af248282fc6b3462e700b8f9a5713110a4"
    sha256 arm64_ventura:  "989c4ffad8b8da9e9e7748e83989601d098c124274d971871c2088f1b98f78cc"
    sha256 arm64_monterey: "f291bfec3c081315cc530beb04e7ff103f5d4fc2fcae93f5afa10da435f7402f"
    sha256 arm64_big_sur:  "2ee65202bb463bf07f09372c95da9ab0d9b23b51eedf6fdf3e3ae5b19a11a7bf"
    sha256 sonoma:         "b7d5802488add54cbeb1c52c2b954058ccdc6904e39010009638bea5d15d6075"
    sha256 ventura:        "481cd4585e8278757a229d2f75f43d9ee51962b3608870c392a37e0d761e8989"
    sha256 monterey:       "39889cb109e62d49a237282be1e978a5c064cc9f8f393446d9b8faf5a39b6bb8"
    sha256 big_sur:        "24327cb6e498cba40d9ae4b1a35161cc7ee112e33d0da33486c4ee4b19585a23"
    sha256 arm64_linux:    "7a0563ea6f1a714b223e0ab839eb0cee2d500c6454e70d2d47837c781280fcfc"
    sha256 x86_64_linux:   "02f41488d9958e0be78a30c5d32d8f2b0e0073f954219deffc6f5f53f11120ca"
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lgphoto2", "-o", "test"
    system "./test"
  end
end

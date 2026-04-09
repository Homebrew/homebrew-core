class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.33/libgphoto2-2.5.33.tar.bz2"
  sha256 "c55504e725cf44b6ca67e1cd7504ad36dc98d7a0469a9e8d627fd0fb3848aa1d"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4787debd14a4f061a5b1dfdb313268a6e03abe10dc39343e135da821f41a6f88"
    sha256 arm64_sequoia: "761131f6530a6f51e1d9d1492af5232cb1217128e3bf73fa235d0d03a3da2118"
    sha256 arm64_sonoma:  "631cdc3341dfc5907fa83887dc913311aa36a0c219261ef9fd7f46cf8037cda8"
    sha256 sonoma:        "2de747a420398a3a4e7b5cb01cec1511e37d7fbe534895f6a76fd9fac18fdc0e"
    sha256 arm64_linux:   "4af836cfd70a87e5927caf8cf9934b3c633f92234a3c369eeff623f6a1e53993"
    sha256 x86_64_linux:  "6c59a4f801f570abede5df74fa27c3fbcd5f9a4c850a3a7be0143cbd51787b32"
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

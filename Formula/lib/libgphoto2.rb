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
    sha256 arm64_tahoe:   "c68e44acb62132269d8b640bfbdc216658e413793c7a17218a7c4f9e37eac1a8"
    sha256 arm64_sequoia: "56c47cf232de5b4b179fca5b188ef3ed22d7f0804d98be2351b42c2cdefbf8a7"
    sha256 arm64_sonoma:  "901f73be2f4d69442f67bf7bcc36ad8a8bedef3584c3a8d9518f525203c10085"
    sha256 sonoma:        "e1c39e6008ef9e7d846cd4c7c6c20d7da5a4658d4ea98096544b5ee039d5b485"
    sha256 arm64_linux:   "86cc3bc890a442918626e8a6243ef5abb72471a216a342a10329e7b4754c4c52"
    sha256 x86_64_linux:  "addf5a20ef635d4498082be132fb0ce992132cc19a1d9d0d88b9f1fc54dd18f4"
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

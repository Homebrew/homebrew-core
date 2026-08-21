class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.34/libgphoto2-2.5.34.tar.bz2"
  sha256 "5df9e774eb4ab6087a193afff84dcafe9f666e3443fe29e73e6779f659ff7f28"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "829fdae4eafad77c84d7f271ace72ed76ac800c7804cb8721f8108bbb31ea74d"
    sha256 arm64_sequoia: "55f881afb02888805368a94150e7683e53d5cc25e92ae808ac3dda060dd0d560"
    sha256 arm64_sonoma:  "0226cc48342dcfeb60659c0fcd1f5f53bc91b47fdf40de4918b6646c43edca52"
    sha256 sonoma:        "e81e4aaad77b4932523fcc35cbaf7d9990effb5918dd98d572a71463a3b7433d"
    sha256 arm64_linux:   "817e6e6f8cad50fbfe4a52cf1bb4e498baee076b8ad184c8f330ebae7594baa3"
    sha256 x86_64_linux:  "0e0b3aa2bd20bf1c98f8f6473f06530c9ccccd904dd135f0b831c74aa605d0b0"
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

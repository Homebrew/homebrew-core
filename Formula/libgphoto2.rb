class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.28/libgphoto2-2.5.28.tar.bz2"
  sha256 "9600596a03208c15ed76f2d30441d75261dec00d93e80779ed0fc56f03725ebd"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "5e7638250ede2f536262e889643eb65a97b75017590b48fa77e58b99083007df"
    sha256 arm64_big_sur:  "701e50258ea1063eb44408a394930ed864c076a7f54eb83d123c249ef0296b95"
    sha256 monterey:       "6a0ddbb4822bb047b043b5fe921e61510beb9cd22ae7e5ba39f8f89af864f5cf"
    sha256 big_sur:        "2771425b25fc5daacca8b5c2322f08440aafda9df085069f40fc05c9579972ce"
    sha256 catalina:       "69871cc5fc750b1ae1e73a51113dcc5a9c108df1b423c53f8a2e604df4911bc6"
    sha256 mojave:         "3d9bf09a1d548e7bac00461c93f67fcdd68a48b44f296afd361f2279a9fff175"
    sha256 x86_64_linux:   "6cdad3241d77f35ab799532628c936a1d1917c290ad2ecba095bdbbfe2261db7"
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

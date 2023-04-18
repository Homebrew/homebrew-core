class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.21/libpano13-2.9.21.tar.gz"
  version "13-2.9.21"
  sha256 "79e5a1452199305e2961462720ef5941152779c127c5b96fc340d2492e633590"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9831541fb99ba54ac769167cb49738d5ddc7a3d5aff5c213f35d6296caad7215"
    sha256 cellar: :any,                 arm64_monterey: "70958ca67b42e1da36ad393b0243c7d182d5413f1c8e83e5d6c47b513b0f3ff6"
    sha256 cellar: :any,                 arm64_big_sur:  "bcafb2c87069bcbc4072ad10e5d0e971761d55b66470f5020b9571b1fbd48c23"
    sha256 cellar: :any,                 ventura:        "c5b9ce7c25bf31746f677554ae6d8efc7a6398f7b2809dc80b160a6bfaa73630"
    sha256 cellar: :any,                 monterey:       "cc0ce40a573784a891039fa691945d6ccc357bfaf0cfee2ae030bd8f6fbf813f"
    sha256 cellar: :any,                 big_sur:        "86d6ebc7e57157f40337083697758ad334cda89dd1b6f98eb470cae7bd8ffa01"
    sha256 cellar: :any,                 catalina:       "23a591c1c9367006f7477e1dc8633f17452082d36197536bdf768e1e51692302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "824c6d89f876646cf10dafe0db21c13fd7493495c923c1c0b9158cb5aa93d33a"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "zlib"

  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end

__END__
diff --git a/panorama.h b/panorama.h
index 70a9fae..2942993 100644
--- a/panorama.h
+++ b/panorama.h
@@ -53,8 +53,12 @@
 #define PT_BIGENDIAN 1
 #endif
 #else
+#if defined(__APPLE__)
+#include <machine/endian.h>
+#else
 #include <endian.h>
 #endif
+#endif
 #if defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)
 #define PT_BIGENDIAN 1
 #endif

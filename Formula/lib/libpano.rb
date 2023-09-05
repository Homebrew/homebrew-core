class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.21/libpano13-2.9.21.tar.gz"
  version "13-2.9.21"
  sha256 "79e5a1452199305e2961462720ef5941152779c127c5b96fc340d2492e633590"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "38ab46b85193d465e96755ade2fd24f53b83aea91aafa58f7a95d232e815cc81"
    sha256 cellar: :any,                 arm64_monterey: "dcbd9828f83595a4bf84446fb108dd5cc3833654db8c6b9f671a3222560d6205"
    sha256 cellar: :any,                 arm64_big_sur:  "e0c24d68e47dd79a020e210d16ef60e0d366ab055ea5398a26ea503375b28892"
    sha256 cellar: :any,                 ventura:        "2299a8a2a47375fcb10b9e25de60074b0febe061f74d3087faaabeff05b3194b"
    sha256 cellar: :any,                 monterey:       "b616750f08a7f0a7b3998016bea3a61d5980004348b6cb48251aa4154fd29f63"
    sha256 cellar: :any,                 big_sur:        "23abf35e187127bf5bca7fbaaa9fd99fffc6909a33965089c2ee36a174c8d046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33708e316d754864b4302b86031fc23b02e7b7e53a098880278b2aa864cbc5e"
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

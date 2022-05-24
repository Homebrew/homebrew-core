class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.21/libpano13-2.9.21.tar.gz"
  version "13-2.9.21"
  sha256 "79e5a1452199305e2961462720ef5941152779c127c5b96fc340d2492e633590"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dcbafccb35edcaa11f257d32dfb9e712f9171493d84c37782ab19e17293b8759"
    sha256 cellar: :any,                 arm64_big_sur:  "1ddf2d1cc08c78844ac583dc51252c73eb14fd21f3a696e06d838302fed18e2b"
    sha256 cellar: :any,                 monterey:       "d86bbb785bcdd59229e04d1125949c9e33554741cb306981483c44edbc0ab085"
    sha256 cellar: :any,                 big_sur:        "73ea3c14c4f95c7b34b8e92d728d2e69b8d396a7785fe6afb8122e7e61f5f258"
    sha256 cellar: :any,                 catalina:       "eaeb95055eb6c09fa473ff41dfe71f8927078a6da552ce74acc35e26548b936a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126a0aa926ee6ac920f8045c5b7f89375c927061446316271a16631050de0c14"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "zlib"

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
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

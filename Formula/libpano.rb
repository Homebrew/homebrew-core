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
    sha256 cellar: :any,                 arm64_monterey: "6d384b4a21347cea34a2fec5e6f360f06e066c175a09818eb9278356f2975f9a"
    sha256 cellar: :any,                 arm64_big_sur:  "62acefefae0a9e7773c8040bd41706263f85563dc6533ed922d2cf4ff565f7c2"
    sha256 cellar: :any,                 monterey:       "f3405fc554fc285e20958abb8dc920ac61a205bcbd03ab8eabde83b76c1e9a48"
    sha256 cellar: :any,                 big_sur:        "b1cb70b0d3ec17309a8c71f4d30ead3cee9c72f4efd8d15b85c9a5821de6fea6"
    sha256 cellar: :any,                 catalina:       "07de3b8c00569f6d7fe5c813eec7e72708ee12022d85003a64c0959d87057a1e"
    sha256 cellar: :any,                 mojave:         "8ed168e1c4b45fdc7815d6c275c0831f3b8450481cbd6b8ff8654d84f0486cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9f6180154f15419ba4f2486eddd5f110098ebc3150b2007f867e9459c24b4b"
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

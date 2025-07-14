class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.22/libpano13-2.9.22.tar.gz"
  sha256 "affc6830cdbe71c28d2731dcbf8dea2acda6d9ffd4609c6dbf3ba0c68440a8e3"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano13[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e0b93764142133cf6a62e5d9512bd7ba1a82ebabc2ae3660c62b345cf49c8af3"
    sha256 cellar: :any,                 arm64_sonoma:   "42f3f8617fa4d805513768324ee0de1ab490e90078a7481c8c1344a75850b7dc"
    sha256 cellar: :any,                 arm64_ventura:  "c2776938006e3a0b5bdc316e4a1dbcc4244a9193b43fa92b8dc04d251385af1f"
    sha256 cellar: :any,                 arm64_monterey: "9446d3ebad930d7626cd713b2145c58a0f41a128669a26f7f8597a9836339b7b"
    sha256 cellar: :any,                 sonoma:         "0af56e6b3b09c834eeb1e761601077adf59aa8182c2bb3e7bb6b0af281d7b786"
    sha256 cellar: :any,                 ventura:        "7ed03995775f0db50976850f24874ea177cfb4dce9110ac0efbac4b9952f3bf3"
    sha256 cellar: :any,                 monterey:       "8c972fc65b94671e0d619e86fbcdd48b04fd4223c3b3cdd9888ae4e944447919"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5a4729da262a95f93470e8ceb3646a42d86f1375fcf624c462f867411743b044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30623a39cfd32fb1230f6ac0326235ef16c71e907fdfa0757c689e5d495b0980"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "zlib"

  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    panoinfo = shell_output(bin/"panoinfo").encode("UTF-8", invalid: :replace)
    assert_match(/Panotools version:\s*#{Regexp.escape(version)}\s*$/, panoinfo)

    stable.stage { testpath.install Dir["tests/simpleStitch/{simple.txt,*.jpg,reference/tiff_m_uncropped0000.tif}"] }
    system bin/"PTmender", "-o", "test", "simple.txt"
    assert_match "051221_6054_750.jpg", shell_output("#{bin}/PTinfo test0000.tif")
    assert_match "different values 0.000", shell_output("#{bin}/PTtiffdump test0000.tif tiff_m_uncropped0000.tif")
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

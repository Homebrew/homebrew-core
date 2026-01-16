class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.23/libpano13-2.9.23.tar.gz"
  sha256 "e7c076d37a14c39434962115e47ddbe18452ca3de5ce40e2aaefa7cf5815ea28"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano13[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae40d74c1e27009a5d00513ce87a950a28b37eaf407b470bdb13f786b5074479"
    sha256 cellar: :any,                 arm64_sequoia: "fbac0545d8141c470673e085b138198a2bb6d4015670a61b9e2763c1d2169f26"
    sha256 cellar: :any,                 arm64_sonoma:  "c98a4e9f9e341fded546ba27a759ffeb1f4ff209636760a81640980ff11d88df"
    sha256 cellar: :any,                 sonoma:        "8171b674a244d4c621dc68e41ffb4866eadd5a2f030a7ef0d4c0620de30b6948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28b9466184695ce7c4fdaecf05da9fcb4aa6932e50a338824edeaf5755f643a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "383c63f24f0dfd1509743d14d00c4878bbacb3c446596ee1e9df707fcc883aed"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "zlib"

  patch :DATA

  def install
    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]
    # Workaround for CMake 4 compatibility
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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

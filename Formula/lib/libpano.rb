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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bed5e7b25e2109ea77ea76567c3197f60752d2e866aefaf18ac4ddf2c248cce4"
    sha256 cellar: :any,                 arm64_sequoia: "a4d99700b3f78d2d2127aa44af61277d21aa9af993af1561bf37d8709391480e"
    sha256 cellar: :any,                 arm64_sonoma:  "a98362bc2e1df8ab509bf95808ec9b06478231620ea1643388dd50dac292206e"
    sha256 cellar: :any,                 sonoma:        "eb39a8e4827912f36aa9693b13dd0ed1f588c98f3a37112ab85977569c9aabe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a42aea9bc8bd4019a965019b13c7147670db0b28780e31105dd2ddc68e9dbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f128fb8a847e170a59c01964478ae7f141ae3be4683a26a3f008366376ac28b6"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

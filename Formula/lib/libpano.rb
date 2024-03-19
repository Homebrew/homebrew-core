class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.22/libpano13-2.9.22.tar.gz"
  version "13-2.9.22"
  sha256 "affc6830cdbe71c28d2731dcbf8dea2acda6d9ffd4609c6dbf3ba0c68440a8e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa89b0c345b31acbd05ed19fe8b83430f0f8441baf35b7c1da5ca1b341a81911"
    sha256 cellar: :any,                 arm64_ventura:  "09d3187f0a8b6590702191a736d39dc04c76ef206a2f393e07a0652f8d4f0799"
    sha256 cellar: :any,                 arm64_monterey: "d68b6fdb9f52b179bc7fabaad1c8799e379dd98083a90a97ad5f44882e2490fa"
    sha256 cellar: :any,                 arm64_big_sur:  "7518dd1633746b0b8d6aa05782d944b8d350a4264141170692b47d7bc5953849"
    sha256 cellar: :any,                 sonoma:         "4f5047edffe197205f3aa8b855884ec32f51833184d630b292a62dc91afff718"
    sha256 cellar: :any,                 ventura:        "e3790ccba7cf7d242b43bdf1c95138ed90d820ee9c95c1b96e4eb97a1f2200b4"
    sha256 cellar: :any,                 monterey:       "6f01278cff267c140af795a8fcb77b931b67bf8873521fc820b4d439377cb28b"
    sha256 cellar: :any,                 big_sur:        "864d4572804488806ef439af804ac7e3a317e7a088836af1f76236ae0e8c4292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19decc93a3e5c3205bcee01f256771af1fb2386d6d8848b2c74cf3c761972ad"
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

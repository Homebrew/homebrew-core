class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.9.tar.gz"
  sha256 "992693a532eb15b20d306e6aeea1a1a6501bd19dca993ebe9a95fd22d6b7fd74"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4fb358ff7ee3e108e07ad3c5a32b4f87aff0ee3960acee095a1f02fecfa9c4ec"
    sha256 cellar: :any,                 arm64_monterey: "4240fdfc437b1a4d3dba615936aec573701dca649656ed5e9f87ac1825f184ac"
    sha256 cellar: :any,                 arm64_big_sur:  "9eb2c564eb051a4ad293e06dcddda55fa56a22224268e767ae801cad43a895f2"
    sha256 cellar: :any,                 ventura:        "3fe87af529f4efedfa31cff4dda63163e1ecdb48fbfedb1f22d80501619ff148"
    sha256 cellar: :any,                 monterey:       "25c8025d949117e1015faea0514709cb04e695a0d9277709d88324d4fc7682b4"
    sha256 cellar: :any,                 big_sur:        "ef8929e0fd26595ca586efe878e17eeb5f08e60bd0f079dce8a200b33d895c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7be1c76f96a7da6fb18bc567a244306425449a5d13484b2223909e325504ed"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "minizip", because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz_compat.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lminizip", "-o", "test"
    system "./test"
  end
end

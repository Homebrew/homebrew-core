class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.10.tar.gz"
  sha256 "d4a549731d8c7074e421dbab6d8b8ad0a93067752fe767c464f0f40fa5f0a80d"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa192bc4b4833b8a5890049d7578960fb2c9ab88f1ddf75aca113acc81245923"
    sha256 cellar: :any,                 arm64_monterey: "80301a3df4912425d28ac0b7453f3463337dfc3f34f09e7d8a71806eb94104c4"
    sha256 cellar: :any,                 arm64_big_sur:  "5e2a6efb97ec3e1066de8e289f8b51440aa32966fd4be30d183995dfad8f9786"
    sha256 cellar: :any,                 ventura:        "777f0bdc187fe0a10be9f5e9fc0f4e158928ea1855d7e51d9e56c2aa461d29fc"
    sha256 cellar: :any,                 monterey:       "c9e6ba5b3d45f787ea7c6c1e4b80bc59daeba899396746420c3ac9eb18217d77"
    sha256 cellar: :any,                 big_sur:        "77904402c1db0662dd84aacf589e67986d5a05606de1439b2dd4bafb2f170ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90232fb5ce6119b6315b7bb1d4b39e1754a2ded4b54c1fbccc3225f0e8c4d204"
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

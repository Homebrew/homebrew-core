class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.9.tar.gz"
  sha256 "992693a532eb15b20d306e6aeea1a1a6501bd19dca993ebe9a95fd22d6b7fd74"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "08ed127760491f6f2ea54db3f5cf50518ce27d736ee7e17347aa72d86aff79c6"
    sha256 cellar: :any,                 arm64_monterey: "76b7012e487529a82c0855d63dffc82a2540677eb7be11fab19c8805d1b28440"
    sha256 cellar: :any,                 arm64_big_sur:  "87796475924b64907c2a30c14234952ae77c8816185a9b225575efd5ea848963"
    sha256 cellar: :any,                 ventura:        "909eb70c9f37f1df9d054f0c8dce037c1ac0cc4f673c1792d32cdf9878c8e902"
    sha256 cellar: :any,                 monterey:       "ce1f3a362d0668c88558188a00e9b39b783ef025747719f2b9cb9753cb279745"
    sha256 cellar: :any,                 big_sur:        "0b12b11e68e45558f20918f97e77f1fd04db4f00bbcc76b3b167af23705550f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e019ab6a66b2b38cade0ce3bc9daf3446a44d9fc379e2cc5d54123a17c5c1ca"
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

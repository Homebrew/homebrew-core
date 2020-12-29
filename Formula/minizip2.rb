class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.10.6.tar.gz"
  sha256 "c2889690b1a1f55898d37d3fb51f05183a4861fb7d53ab702c6a5777bf232b75"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "a31d89be3574f9bff5a437254b3bb3245ce73e8c02952d36f20195a100f5b0bd" => :big_sur
    sha256 "5276fa7ed2c9d2caf4999c4563b9523a63071d7c86f62df9e2d697d9564ca13d" => :arm64_big_sur
    sha256 "cc7cb586eead3a60df1605d9b7bf9b6b90205cf49869a9ce6f781b45a4ae693c" => :catalina
    sha256 "76afb235aea00f06858d62369363ce01e06f7c009afc380b41f5d6a88bc6a8f7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  conflicts_with "minizip",
    because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    because: "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", "-DIconv_IS_BUILT_IN=on",
                         "-DMZ_FETCH_LIBS=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz_compat.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lminizip", "-lz", "-lbz2", "-liconv",
                   "-L#{Formula["zstd"].opt_lib}", "-lzstd", "-llzma",
                   "-framework", "CoreFoundation", "-framework", "Security", "-o", "test"
    system "./test"
  end
end

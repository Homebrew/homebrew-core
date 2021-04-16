class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.1.tar.gz"
  sha256 "96c95b274dd535984ce0e87691691388f2b976106e8cf8d527b15da552ac94e4"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ad8c82b45731b2bf0c2ab381a03ca1ee04b2a0b77d1a82cf9c96e943aded479"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e9ce92109dfe17d988a2007bb488cba82e7840e4432589c3d3ebd99d4c73fa4"
    sha256 cellar: :any_skip_relocation, catalina:      "4f2dfbfa9b7adb2bcde15d974ca0285887a1d148a47d1c7800b9b3ca294d68ff"
    sha256 cellar: :any_skip_relocation, mojave:        "ec319bfa442812f8c5ac517d7f1eb231725a6b3e24449d1acc48700168376ced"
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
                   "-lminizip", "-lz", "-lbz2", "-liconv", "-lcompression",
                   "-L#{Formula["zstd"].opt_lib}", "-lzstd", "-llzma",
                   "-framework", "CoreFoundation", "-framework", "Security", "-o", "test"
    system "./test"
  end
end

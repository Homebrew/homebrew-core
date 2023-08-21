class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/4.0.1.tar.gz"
  sha256 "63e47a2b4dbac0da501f43f4da74f118dfb3ef0dee0ffbbe89428271002260f8"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e484205371faa8b30f0509e38cc1347e70e94d99f9e865ef91479cad893e5ba3"
    sha256 cellar: :any,                 arm64_monterey: "550ac0a95b97f5804ab42b3b58ad9d2607ece88f7fabf814da5b8b37bedfd4e5"
    sha256 cellar: :any,                 arm64_big_sur:  "62c51c16e85d601aee766b170086ade14aa5e52558a60961307e119b3061cfb5"
    sha256 cellar: :any,                 ventura:        "53d10a56a333757da78113d470b41399f56801924ddd1b3931a45a25796e04eb"
    sha256 cellar: :any,                 monterey:       "e4d99c38740b4b1b6a6e88d1716216ae80b9fc0d4789913dde7a2d0c047b9399"
    sha256 cellar: :any,                 big_sur:        "dd08374028fcb1670712821f20d109cb416a6929f4327b1bbe4f962a06d6c3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f4cfe9d958b6d6ee738b89bb4fe425f82e0ab463b8ecb96d92601dfdf857a2"
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

    system ENV.cc, "test.c", "-I#{include}/minizip", "-L#{lib}", "-lminizip", "-o", "test"
    system "./test"
  end
end

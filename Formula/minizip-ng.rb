class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/4.0.1.tar.gz"
  sha256 "63e47a2b4dbac0da501f43f4da74f118dfb3ef0dee0ffbbe89428271002260f8"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "caf71e19acbee5bab936b4c3069892f8706855eccd387f9a58e54cc4e23d5575"
    sha256 cellar: :any,                 arm64_monterey: "73995a7ce9e1053e5e0eed917060a79062410889df9458d69fd64ba485294503"
    sha256 cellar: :any,                 arm64_big_sur:  "bd4fcaba2580a27c590d8484de3ff4098c235504da791c2bc87df096e2361327"
    sha256 cellar: :any,                 ventura:        "55e4a73f2f6244050c09bf1a2d471f7190a7e42f58a30c697fbf55787cf1aeda"
    sha256 cellar: :any,                 monterey:       "f34025761a09743053c335b5d4dd8476d50a33ab12dfef88bba02b2f7e792cfa"
    sha256 cellar: :any,                 big_sur:        "4df600e796d4c461266acffad28794a1621b77e4dade70323affc8f418f31c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f4ecd9e3bbbd0a6739401cf35a138c5de1860325f88d66f25b5e2e6ce10e6c"
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

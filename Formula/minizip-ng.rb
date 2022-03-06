class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.5.tar.gz"
  sha256 "1a248c378fdf4ef6c517024bb65577603d5146cffaebe81900bec9c0a5035d4d"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae8c49783a26f6dad84e7631a095c2c5171b8464a6b35c3fe308936e574e5d34"
    sha256 cellar: :any,                 arm64_big_sur:  "6f22989c5000fdfe78bcf91d301b91af32d18a59dbb937da48e3401b207d1ab1"
    sha256 cellar: :any,                 monterey:       "b450f04c3f51f25628b37994a175d09ff0d2dac77bb380bc760445632d859e19"
    sha256 cellar: :any,                 big_sur:        "49c832e22964616d4186b84a674502c12f605249d446677cadb3258e981fe398"
    sha256 cellar: :any,                 catalina:       "0018fe1fcc0c4d84b7e4bf3e86376f4ca6a4cdcef58406b7fe3e1cc1aded8605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae25a36cbd160439f73ccd4c26d056ecd99055ff16f65c33feeff179108da1d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  conflicts_with "minizip",
    because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
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

    lib_flags = if OS.mac?
      %W[
        -lz -lbz2 -liconv -lcompression
        -L#{Formula["zstd"].opt_lib} -lzstd
        -L#{Formula["xz"].opt_lib} -llzma
        -framework CoreFoundation -framework Security
      ]
    else
      %W[
        -L#{Formula["zlib"].opt_lib} -lz
        -L#{Formula["bzip2"].opt_lib} -lbz2
        -L#{Formula["zstd"].opt_lib} -lzstd
        -L#{Formula["xz"].opt_lib} -llzma
      ]
    end

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lminizip", *lib_flags, "-o", "test"
    system "./test"
  end
end

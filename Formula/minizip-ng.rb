class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.3.tar.gz"
  sha256 "5f1dd0d38adbe9785cb9c4e6e47738c109d73a0afa86e58c4025ce3e2cc504ed"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "55e95326e5c93213a0cdd254871ddf311dd4a493e90aab65880dec8e0bdb9b7d"
    sha256 cellar: :any,                 arm64_big_sur:  "1c9600fafaf889c6b370ce12904552909a3f833580c5d575ce5d982214470ffa"
    sha256 cellar: :any,                 monterey:       "4d14ab3655510efcf17bc4f4d6bca7003e9b91998e744e776584741f7c082b9f"
    sha256 cellar: :any,                 big_sur:        "07f7ab4bd6c1d82d98ed205ba07ccbc44ead3c9d27775c66884ddfa29e50ad89"
    sha256 cellar: :any,                 catalina:       "4cb41d70d8b612c81bac2e143403e0ba1e4b2eae2972e9680b14ec906deedc86"
    sha256 cellar: :any,                 mojave:         "6def73d2083177581703aa90b3d9db733638975c980e9293d60e47474429e040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eefb6f377cf037770f8e674016d02e389e0dcd9035a97c6b25439d4e8e9ae3e2"
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

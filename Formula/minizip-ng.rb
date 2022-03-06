class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.5.tar.gz"
  sha256 "1a248c378fdf4ef6c517024bb65577603d5146cffaebe81900bec9c0a5035d4d"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2a947a17f83a0cab9fb5e233bb4fee6d886457c190200f61fc03e6a9eebcc19b"
    sha256 cellar: :any,                 arm64_big_sur:  "093472912723d17ffbea8c19f279f55111e4aa8cd32189b4380e6599305baa44"
    sha256 cellar: :any,                 monterey:       "83c025858a67665616fe1d3dd2f3180c2300d0c55544a8e085639fb6d3767be4"
    sha256 cellar: :any,                 big_sur:        "a0559ee971485ef4671eed6d93c153e3a55937ef1e0399f7dc1ee6e849be35d9"
    sha256 cellar: :any,                 catalina:       "3b1f1ee5d3894ff439a1530b8c65743baa852d3ebf04c203c0fb1aa951f8ea36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80df92ff8b1f8f9c0899cfe444d3c7a25860f535e6ecc9a27821618e7149cbd2"
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

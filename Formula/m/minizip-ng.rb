class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.5.tar.gz"
  sha256 "9bb636474b8a4269280d32aca7de4501f5c24cc642c9b4225b4ed7b327f4ee73"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e2ea648fcc3422bc1c9dbc9a53bc4a93b4c5d9cce2027dbcd30aba29486fb94"
    sha256 cellar: :any,                 arm64_ventura:  "feb2a714e2fb7c25fdf6543fb140077dc78649e439d3221cc2e36eecac8a8a1f"
    sha256 cellar: :any,                 arm64_monterey: "ff510c9028945edb54fd19167ccc766a4f216da3fc43621435c25a2d813ef4e3"
    sha256 cellar: :any,                 sonoma:         "24805396f0c54848c8f93751f329e12a0c255a915fc6a3bc736a81a008b5cb3c"
    sha256 cellar: :any,                 ventura:        "cf5aef26225db36002ad12c50b05fafe1f92d48fef0be73485efb7792b4dd387"
    sha256 cellar: :any,                 monterey:       "fc3576a52258d62e73a50268c36f978e779f9dbeaeb0e2d8320dd58ed8dab688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4350428755b3345baad8923d650fa26670f9a750674f7f2c8067dc82c7e4f3"
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

  def install
    args = %w[
      -DMZ_FETCH_LIBS=OFF
      -DMZ_LIB_SUFFIX=-ng
      -DMZ_LIBCOMP=OFF
      -DMZ_ZLIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip-ng.a"
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

    system ENV.cc, "test.c", "-I#{include}/minizip-ng", "-L#{lib}", "-lminizip-ng", "-o", "test"
    system "./test"
  end
end

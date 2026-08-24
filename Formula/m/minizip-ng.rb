class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.2.2.tar.gz"
  sha256 "71af7b9799856d8b03619df3949e9c1be9703f8de0795af71399ba283cb27aac"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8cab9fe8070040f62235accd234ee50857f8499dc42866edbe6575e20899afe5"
    sha256 cellar: :any, arm64_sequoia: "a6bddf61850919db0f00c2db6e8df33b590b255765c26fe47fc7fd0dd314852c"
    sha256 cellar: :any, arm64_sonoma:  "7341652834f05bd3a3e851e87c11ee30c63778b9b94afb1b5ba333414fe90882"
    sha256 cellar: :any, sonoma:        "00adbf770209ca79b14e81a72b2e50098cc5fb16aeb0373e2713a52f95544e5a"
    sha256 cellar: :any, arm64_linux:   "9a811e393d62ac722750aa8ff09ec1a2d3ede379e8eee27204409d37bfab2dfd"
    sha256 cellar: :any, x86_64_linux:  "0f02d738511328c8c08a9a424bb06d44df5eaf23386767d815d45f02ba8be17e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DMZ_FETCH_LIBS=OFF
      -DMZ_LIB_SUFFIX=-ng
      -DMZ_LIBCOMP=OFF
      -DMZ_PPMD=OFF
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
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz.h"
      #include "zip.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/minizip-ng", "-L#{lib}", "-lminizip-ng", "-o", "test"
    system "./test"
  end
end

class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.5.tar.gz"
  sha256 "9bb636474b8a4269280d32aca7de4501f5c24cc642c9b4225b4ed7b327f4ee73"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1493c8ed642685b17f89e9615d48eb12c7e4f91a1442a35663df194597c093b6"
    sha256 cellar: :any,                 arm64_ventura:  "4847ee1eb6c87e465f3f8244f780cb73de8dbcf32f0655fc79d51ccbd9cff205"
    sha256 cellar: :any,                 arm64_monterey: "ec5f88fcbb1ab2aae3f6d8164eafdc8bd2e645600cad4af9bd12779c912f0ec3"
    sha256 cellar: :any,                 sonoma:         "409dfe7e5694a42a525f557ecc0e47302efff28254d7935df90a3f2bb51f6bff"
    sha256 cellar: :any,                 ventura:        "ddeaf4570a38989c26cc1d9380858c3f93e72fd3b18e70ae7a4f28c154f43c24"
    sha256 cellar: :any,                 monterey:       "a4ae470fffb451ea380556b9523531554ab8e57acf66b5aff8ef1d800db14e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73b5ab8fc7c2ec053c67b6b38a83bb646c2e64beb23479a25681ee4d5043c44d"
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

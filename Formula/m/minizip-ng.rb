class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.2.1.tar.gz"
  sha256 "3cc35c2cb925dbe67cc801e3234b31b0f30197812a99377352fa1b551ab3d011"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02c53028eb50485f554371a65e128575b4460e65cae3125a6ae90421847fca6a"
    sha256 cellar: :any,                 arm64_sequoia: "41d177457fc9fd7af37b608b314c193883b41644390a7179eacc2ff4caa128d1"
    sha256 cellar: :any,                 arm64_sonoma:  "6ff38323e940b58e79cf732ac4cf7f5b7adec62f73a66aa65f2ca3bf8442a138"
    sha256 cellar: :any,                 sonoma:        "21baa62cd8c44df28b98c0aa884993847310ee7741ccd7aeb665a779966a4f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ee8d773e8593260e58169246ddcdd2ed491460fb6b14e2c8fd4937cbdd5eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969fb9fcb3a3729cad28504fc87168f4b2e941ff41a4ea91396b015cc956e414"
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

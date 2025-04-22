class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.9.tar.gz"
  sha256 "353a9e1c1170c069417c9633cc94ced74f826319d6d0b46d442c2cd7b00161c1"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f12f1afaa1a105cbfe42bc96fe718fdf39f6956b51ca32c76fe289c86b83ec0"
    sha256 cellar: :any,                 arm64_sonoma:  "5ab0aabe48dd01af06bb1d5770249c847cba21c30ffcdd99a0c287aa31065fae"
    sha256 cellar: :any,                 arm64_ventura: "a28efcc113a97d01e803a1e890a8cbcd3ed46d2bb741c552a27e6606add0b572"
    sha256 cellar: :any,                 sonoma:        "21c01459a3b484979bc4b4826797406fc84d5ac521e006a92af50198d5beba9c"
    sha256 cellar: :any,                 ventura:       "377c959bc7886683d6136582e6e2c896885d4f35db54741945ed87d9aee72ebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b76c30613d858447ab1600102c90bdf721e9c130a72996cd46d2e944101f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f50444e2682a6c74cc674b8e4d23623645a0240843d6511263da53d36a1e273"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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

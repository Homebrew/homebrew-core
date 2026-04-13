class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.1.0.tar.gz"
  sha256 "85417229bb0cd56403e811c316150eea1a3643346d9cec7512ddb7ea291b06f2"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1c5d344d8e472115ba7088e581d5db6e572a8a0552917df353380bcf5eb53b6a"
    sha256 cellar: :any,                 arm64_sequoia: "c39144f2361315036eb8d8d2e921057258630455734966530a5ba5efb2c7ab6c"
    sha256 cellar: :any,                 arm64_sonoma:  "cef7c1e74c9196b64aede7f40e391907a783738955c8f943b8be48e3fa6fb0cb"
    sha256 cellar: :any,                 sonoma:        "cdf7ea3520821d64e900f83ecd91fcdf45f35c9094e044b9420bc41f82b60a5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4374f85c5cfcc5f9ae93a213c482cd643b423416f3a3f27f6b5a297559df24c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca71475bc122013714a7ea36f94d6862368cc8a03ef6ae89631cec6743c6a6b0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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

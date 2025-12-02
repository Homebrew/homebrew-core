class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.10.tar.gz"
  sha256 "c362e35ee973fa7be58cc5e38a4a6c23cc8f7e652555daf4f115a9eb2d3a6be7"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4da97ab1810ce6fa9251410d4bb9f9ff55c69c54335ae4c0e02a19d9cc5a3b68"
    sha256 cellar: :any,                 arm64_sequoia: "f0172b547c9dfaf812dea4d560e8fb9aa879aed5ff8bf497c2a2625929853d06"
    sha256 cellar: :any,                 arm64_sonoma:  "e8a04d677e0ca6bfe1a8573d6f5fc3e50954fe2e45dea1c59e36ae518179ec05"
    sha256 cellar: :any,                 arm64_ventura: "bbfe1f69b6da17bb8be57d1451864d68100c799923796d8777bab9fae75c2286"
    sha256 cellar: :any,                 sonoma:        "0c2b4b52eb15c5b33773d44473121c1bac2ca53297931932bfc744fd3ecf8b3c"
    sha256 cellar: :any,                 ventura:       "69fb82c03a680bdd98be7662b3c861474e468d8a3a0abfc3eaceefba7e4d8c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "881da858fe2c257d124471bf7cc635755dbdf53da6a7b9e75f05dbe4d2858e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8e136ccc36ba064833246e031359432b097a6170a5d7b53cc249ae57a64a78"
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

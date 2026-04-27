class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.1.2.tar.gz"
  sha256 "3738c742c663fda43f1e510b8eeef312917581a712c89cb253f682aaef8c732f"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "652e206cf55d7999bed48042f6231b414b948079c677e9ed302a9c99017acf84"
    sha256 cellar: :any,                 arm64_sequoia: "0f0cdcf802459491aa6ca0ad02377f00da00bdc7550af0156d0be39ef888a973"
    sha256 cellar: :any,                 arm64_sonoma:  "bcb6fca4c512e22b198bf85d28b763d87df5613a3dee38f0be45396894417c59"
    sha256 cellar: :any,                 sonoma:        "a195fcf34eb72f8938469eb9924f7ad8225c13ca25dab03e60a8ef1041dff512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9be5906d844d3a8320fa28e79cfbbdcf38edbdf8a476558074a062acec02ca5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cbbce26ec60e8065365c65523a78e5b4ae8f4ab4962675ec07f09227abcb3d8"
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

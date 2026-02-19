class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.1.0.tar.gz"
  sha256 "85417229bb0cd56403e811c316150eea1a3643346d9cec7512ddb7ea291b06f2"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "beabdbaa584b7c77ab8faf4f589a0cc4de976bb982f21988df54f5f9b8cebc57"
    sha256 cellar: :any,                 arm64_sequoia: "24cdd66a3864222e895266cd80b4e68f8d380e2a741b9d3f1abaf06865eaad4d"
    sha256 cellar: :any,                 arm64_sonoma:  "8845738825d6c9ebf64e969af35f46b585bf71e849a972a4a9729a39a05d8d53"
    sha256 cellar: :any,                 sonoma:        "8a79f9af08d1f40a28df0c78fbc0802f8bcd19d84c179d8d592d60382bc11de0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e16a64548cb4c988893f703c48c43cbc7b7f786ee92c2ce87b49e8134fdc069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc5b232039c29b016bf94e611e9a3a545ce1446447b31377a4c7cca26b86059"
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

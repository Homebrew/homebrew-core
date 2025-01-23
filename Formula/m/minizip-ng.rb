class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.8.tar.gz"
  sha256 "c3e9ceab2bec26cb72eba1cf46d0e2c7cad5d2fe3adf5df77e17d6bbfea4ec8f"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97f310adcc883207a29cc100cf0c413fc3171984c75e7da2e09ea8a4fdf8cb33"
    sha256 cellar: :any,                 arm64_sonoma:  "a1acf2df956550a474b1f7ba493e0965ef02ff796390b6216ebbb15986c83862"
    sha256 cellar: :any,                 arm64_ventura: "fc08746ae2c5c4350d9d62e69b4c9c9f6ac8fa988448417ecd76e3a7287ec1dd"
    sha256 cellar: :any,                 sonoma:        "d26b0e89901e4046ae3492a9366992598a24c1f4ad40cef0afbcf36fc34d8440"
    sha256 cellar: :any,                 ventura:       "10475ef77199558419a4e026fba1df63e4c025dd22f940766f5f549fe494baf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9baaa7081cab2ebd2c05cd6fdbfe3007eda6530543cd4310c73cd932eb55b71d"
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

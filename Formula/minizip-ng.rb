class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.7.tar.gz"
  sha256 "39981a0db1bb6da504909bce63d7493286c5e50825c056564544c990d15c55cf"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0bf1f6011ec571018194f3467e7539a3af75388303f21671ed1d32fed5a0365c"
    sha256 cellar: :any,                 arm64_monterey: "22207f2d5149735853ae60463b0e866eded5a09b6743de04709012b23d2f113e"
    sha256 cellar: :any,                 arm64_big_sur:  "e9a0ca63e9ce8e1e4cb83561d7ff483c93944b9c538f307c765702b194f4bfb7"
    sha256 cellar: :any,                 ventura:        "d9645e1552f9ec3e8ba81a0a9a1e47ef79d2298240c2490c00d7b03e83ee4553"
    sha256 cellar: :any,                 monterey:       "02eb5bca48457f3975a9ca01a1ba0023cb043cabebc2424b47701080c6537b66"
    sha256 cellar: :any,                 big_sur:        "13c046389aa939f40a1c24f734d2afa42cf6a763d661091322cad1789f79de33"
    sha256 cellar: :any,                 catalina:       "d14fd2c6da4a462e2836705bbf6bf61052768f1926547700d2db5490af40243f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c6fbc6ab323c90915ead5f48ea5fba2053b74310256eab10d9c2da1784a153d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  conflicts_with "minizip", because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip.a"
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

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lminizip", "-o", "test"
    system "./test"
  end
end

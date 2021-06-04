class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.2.tar.gz"
  sha256 "6ba4b6629c107c27ab526e517bdb105612232f0965a6747f60150e5a04c2fe5a"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "0bc8e68ed7dcf20dfd58f566ca03861e850754054e377c9ef05ba7cef4ef4fa5"
    sha256 cellar: :any, big_sur:       "4f631f11f24ba348c72f5458facff917a313248eb9a8365539d79c30e1bb3657"
    sha256 cellar: :any, catalina:      "e431dc66a25e00ed03478da0440fd63985af97d0f77d1db76739f7075990c089"
    sha256 cellar: :any, mojave:        "985fec3cb378278cf5b311d1e32669cd63639cfd04e52f55cb0beb34fd55e811"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  conflicts_with "minizip",
    because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz_compat.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lminizip", "-lz", "-lbz2", "-liconv", "-lcompression",
                   "-L#{Formula["zstd"].opt_lib}", "-lzstd", "-llzma",
                   "-framework", "CoreFoundation", "-framework", "Security", "-o", "test"
    system "./test"
  end
end

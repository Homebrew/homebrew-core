class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.10.5.tar.gz"
  sha256 "1c6420d3f3509e722178d9130a57cb77537b34900e7b67acca7e3e2858846939"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "e77e0569fac85496410972551d45a718ff3cf792bcdb92cf49b603faa58f7303" => :big_sur
    sha256 "e632af5ee8fda3fc438e17cd88b6b57f04e9e7d014816c9270c7c0d351ba0a43" => :catalina
    sha256 "7a0a117215461faf323a1bab2f53e94baad2f4c32ce0e2f36f2bdd505d7e9814" => :mojave
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
    because: "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", "-DIconv_IS_BUILT_IN=on",
                         "-DMZ_FETCH_LIBS=OFF",
                         *std_cmake_args
    system "make", "install"
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
                   "-lminizip", "-lz", "-lbz2", "-liconv",
                   "-L#{Formula["zstd"].opt_lib}", "-lzstd", "-llzma",
                   "-framework", "CoreFoundation", "-framework", "Security", "-o", "test"
    system "./test"
  end
end

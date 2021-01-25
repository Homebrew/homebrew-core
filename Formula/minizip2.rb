class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.10.6.tar.gz"
  sha256 "c2889690b1a1f55898d37d3fb51f05183a4861fb7d53ab702c6a5777bf232b75"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "22ef440bea17e14161ab0234e300eb962bf5f45bed7354ce496c955c106d91da" => :big_sur
    sha256 "5f5969b8323a391996b022af84e1eee37653367bee7e753ee7810d5e603ca4e7" => :arm64_big_sur
    sha256 "535b3e0e48e6d4d4f498802dac216a60661045869e87c6671d7ad821838f9240" => :catalina
    sha256 "e473a772186ca62e789f0164f2c8733091c828cda07096c182fa1b7361d4e064" => :mojave
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

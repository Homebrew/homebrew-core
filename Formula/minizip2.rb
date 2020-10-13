class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.10.1.tar.gz"
  sha256 "34f9cf28ee8d933835d476f50dcbb9e3fed56b48bfbcda1a561ce0d3affea663"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "b208e4f752e1964b913c1bda42b129e267093ab8a58abeb41fdccb06ae38714f" => :catalina
    sha256 "fb797578c5c50b1b96f9a77cd0d65f0aa2b5e0d778854749c79ace40f44eaaaa" => :mojave
    sha256 "aea49e67aca487df03c509928714689b292792149fa585764a85c453ff17f511" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  conflicts_with "minizip",
    because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    because: "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args, "-DIconv_IS_BUILT_IN=on"
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
                   "-L#{Formula["zstd"].opt_lib}", "-lzstd",
                   "-framework", "CoreFoundation", "-framework", "Security", "-o", "test"
    system "./test"
  end
end

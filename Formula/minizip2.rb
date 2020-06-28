class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.10.0.tar.gz"
  sha256 "4c7f236268fef57ce5dcbd9645235a22890d62480a592e1b0515ecff93f9989b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ad8ea06edad7b93c33909a43a9f32d218d4d5217177cba2a95b28e275517cc4" => :catalina
    sha256 "675a3a17bf5fadf993b773cc16a16de7efde64acaa904806ed34d275080b47a8" => :mojave
    sha256 "4c01af817e7a53737b2dbd3efe2212d2c62951668465ea5279efa24d10ba3da5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  conflicts_with "minizip",
    :because => "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

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

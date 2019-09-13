class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.8.9.tar.gz"
  sha256 "ad0ab096e325ada77f4c75770ffcb03e3540e4c373e36ee22bb1d47b2b98c36d"

  depends_on "cmake" => :build

  conflicts_with "minizip",
    :because => "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lminizip", "-lz", "-lbz2", "-framework", "CoreFoundation", "-framework", "Security", "-o", "test"
    system "./test"
  end
end

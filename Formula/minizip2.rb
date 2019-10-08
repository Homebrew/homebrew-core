class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.9.0.tar.gz"
  sha256 "d9501b1048064855222a42264ce773eebc29bbad5bcadbbeb22db2c3e65ae447"

  bottle do
    cellar :any_skip_relocation
    sha256 "8da088dfc8380733a9ec95e35ac80bcc6c7142fc0c6de075a792cce3e288240b" => :catalina
    sha256 "fc53e475c3b6d8e78f7e8e6e9c746f52d13549ca851d0c4efc28aea9767742fc" => :mojave
    sha256 "3d67c6a0cdb7290c69b193cb341397f7cd5d5706068db6bd37f10070c79b97b4" => :high_sierra
  end

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

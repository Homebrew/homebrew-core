class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.9.2.tar.gz"
  sha256 "8425399277d9d5e39454e655cfd3eb004607960c8358a3e732f5e741a6b5df0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "eea2dd5c11351eafe018f1cd12dc2a053e4d158950242d311cb68e53868bc1de" => :catalina
    sha256 "5f0f8b2d128a4bf04746be75c549b877b29a365028c86c8cb2382206796ed73e" => :mojave
    sha256 "a6fc8a8620a239b63f8321a4fbd291d20be07db71ba327e72d496de2bdbf9979" => :high_sierra
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

class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.9.2.tar.gz"
  sha256 "8425399277d9d5e39454e655cfd3eb004607960c8358a3e732f5e741a6b5df0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f39325c695c5c3130d8c7f21de674afc97a8479ceec9c161c8716635fbf8d247" => :catalina
    sha256 "106b2a71ea525baf772d29981ca2d1f328f02ed82f56b599cdf4452d8472f520" => :mojave
    sha256 "f03b788a7cb988e272ed3b9fd7d6c0e6ff8cb5414dc050f73e1507c9d4a11baf" => :high_sierra
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

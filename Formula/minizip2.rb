class Minizip2 < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/nmoinvaz/minizip"
  url "https://github.com/nmoinvaz/minizip/archive/2.9.0.tar.gz"
  sha256 "d9501b1048064855222a42264ce773eebc29bbad5bcadbbeb22db2c3e65ae447"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3e526e7c1d3a135d3b2ed02b4f41ed2aa07adde0ca7b32a1ddcc87e9f9f5ecd" => :mojave
    sha256 "937fee9e2b22cd01cc36f042f3e5ae11ace7df1f40ceec7af3d77053c87a0fe1" => :high_sierra
    sha256 "650410384cd941f2b0326e3d9ae0123b17dfca30bf2224a07f2a387bd65ddc29" => :sierra
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

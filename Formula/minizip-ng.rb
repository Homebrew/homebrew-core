class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.8.tar.gz"
  sha256 "27cc2f62cd02d79b71b346fc6ace02728385f8ba9c6b5f124062b0790a04629a"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43a2ab806a9998e1433936052bb06ad74e40758e1eb756aa198ecb77fd3d374c"
    sha256 cellar: :any,                 arm64_monterey: "5d07f21b9801111f7771b1582118a0c6534f5e742ea6e82ed99364135a7f3882"
    sha256 cellar: :any,                 arm64_big_sur:  "35acc454699491a937fce748cbcd2adb204b57d24675f87207a4e93f1fbac954"
    sha256 cellar: :any,                 ventura:        "8ede9fed008a0be3adbdd462ddb42f388025d7d3e5114edf0153e37bd134aea9"
    sha256 cellar: :any,                 monterey:       "78f88c347a1c0671fab15478f44edfe704b6415bbeb57eeebeebd063a8099b31"
    sha256 cellar: :any,                 big_sur:        "601c54d38237a4feba8925296fcc389883cea00e4da2919bba9854cb23ecf567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "649351dbab5bd062b47978035735aa9784761ad66e13e83f5a6f99ebf0e19738"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  conflicts_with "minizip", because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz_compat.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lminizip", "-o", "test"
    system "./test"
  end
end

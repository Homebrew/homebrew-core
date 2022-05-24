class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/3.0.6.tar.gz"
  sha256 "383fa1bdc28c482828a8a8db53f758dbd44291b641182724fda5df5b59cce543"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b1a7fa90dae23cd69a27d16199279ea53d72d92eb96d59a1c4a6e888ccb89d4"
    sha256 cellar: :any,                 arm64_big_sur:  "a61b06c3cd78bafd1a1f89fd6c59b6ee4fb600f4c69eed324c41a720e1129c8c"
    sha256 cellar: :any,                 monterey:       "9ad34a5621f4f7da367f3ab215330236c4330e4620950da57530a98832918f2e"
    sha256 cellar: :any,                 big_sur:        "f3b8970f1b0a42acc3993f3c898a6bc15ed454cbea4b0f13dacc71ce3f64d48d"
    sha256 cellar: :any,                 catalina:       "a0afd89b7407ebe56deee2492654f24b76d5d9de9a10261a9e4429b82198ecb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba63cc8cc80ef8527b37ab6cc5b82471adef4d7cf2dedc33a6d4d74aab9adaba"
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

  conflicts_with "minizip",
    because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
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

    lib_flags = if OS.mac?
      %W[
        -lz -lbz2 -liconv -lcompression
        -L#{Formula["zstd"].opt_lib} -lzstd
        -L#{Formula["xz"].opt_lib} -llzma
        -framework CoreFoundation -framework Security
      ]
    else
      %W[
        -L#{Formula["zlib"].opt_lib} -lz
        -L#{Formula["bzip2"].opt_lib} -lbz2
        -L#{Formula["zstd"].opt_lib} -lzstd
        -L#{Formula["xz"].opt_lib} -llzma
      ]
    end

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lminizip", *lib_flags, "-o", "test"
    system "./test"
  end
end

class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.3/libaec-v1.1.3.tar.bz2"
  sha256 "46216f9d2f2d3ffea4c61c9198fe0236f7f316d702f49065c811447186d18222"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "541259dd6c03672bfbfe4a251ebe70643d5c9a72f264c94315a54b3aafd3e815"
    sha256 cellar: :any,                 arm64_sonoma:  "a663972f5eec805fe10beac16c80701375f3f192c4efd7c42788716437fc113d"
    sha256 cellar: :any,                 arm64_ventura: "6eb5fcc80ba76dbf96d4c686d1596124c2f1cc21648e3b25b95e9a459fa982b4"
    sha256 cellar: :any,                 sonoma:        "60215c8f7af6e44926030f05c6ebc1344f2b23766c234268bf7ea5eb2fc2a1ad"
    sha256 cellar: :any,                 ventura:       "ea401973cd11d71d719097d9611d243ea5eaff7cc110a97136c18d8c74fb2c9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a279f9bb15a0800669f7ac3283c0e46760e09ea1489ae8871d35b9e4a80381e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf37dff4d0fd06ecc1086b33ed1a6fe308509c5b65dd063ff4ef0ca212d8d7e"
  end

  depends_on "cmake" => [:build, :test]

  # These may have been linked by `szip` before keg_only change
  link_overwrite "include/szlib.h"
  link_overwrite "lib/libsz.a"
  link_overwrite "lib/libsz.dylib"
  link_overwrite "lib/libsz.2.dylib"
  link_overwrite "lib/libsz.so"
  link_overwrite "lib/libsz.so.2"

  def install
    # run ctest for libraries, also added `"-DBUILD_TESTING=ON` in the end as
    # `std_cmake_args` has `BUILD_TESTING` off
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"

    # Symlink CMake files to a common linked location. Similar to Linux distros
    # like Arch Linux[^1] and Alpine[^2], but we add an extra subdirectory so that
    # CMake can automatically find them using the default search procedure[^3].
    #
    # [^1]: https://gitlab.archlinux.org/archlinux/packaging/packages/libaec/-/blob/main/PKGBUILD?ref_type=heads#L25
    # [^2]: https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/libaec/APKBUILD#L43
    # [^3]: https://cmake.org/cmake/help/latest/command/find_package.html#config-mode-search-procedure
    (lib/"cmake").install_symlink prefix/"cmake" => "libaec"
  end

  test do
    # Check directory structure of CMake file in case new release changed layout
    assert_path_exists lib/"cmake/libaec/libaec-config.cmake"

    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cstddef>
      #include <cstdlib>
      #include <libaec.h>
      int main() {
        unsigned char * data = (unsigned char *) calloc(1024, sizeof(unsigned char));
        unsigned char * compressed = (unsigned char *) calloc(1024, sizeof(unsigned char));
        for(int i = 0; i < 1024; i++) { data[i] = (unsigned char)(i); }
        struct aec_stream strm;
        strm.bits_per_sample = 16;
        strm.block_size      = 64;
        strm.rsi             = 129;
        strm.flags           = AEC_DATA_PREPROCESS | AEC_DATA_MSB;
        strm.next_in         = data;
        strm.avail_in        = 1024;
        strm.next_out        = compressed;
        strm.avail_out       = 1024;
        assert(aec_encode_init(&strm) == 0);
        assert(aec_encode(&strm, AEC_FLUSH) == 0);
        assert(strm.total_out > 0);
        assert(aec_encode_end(&strm) == 0);
        free(data);
        free(compressed);
        return 0;
      }
    CPP

    # Test CMake config package can be automatically found
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)

      find_package(libaec CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test libaec::aec)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end

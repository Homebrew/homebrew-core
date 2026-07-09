class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.7/libaec-v1.1.7.tar.bz2"
  sha256 "7cf0034eca8f53449252f2fab863d855aedc0520ceb8d3f3fcd3bd601ce4c85e"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d708bade896916d6694d8e85300dff0ae549ccf6d1ad9709577e8777ad087f5"
    sha256 cellar: :any,                 arm64_sequoia: "55cb3f883f990b21ea7cade333059e70c6ed23c7b6037456b8100ffe653b7d49"
    sha256 cellar: :any,                 arm64_sonoma:  "209fa55868480f64a25cd1bb82208463aca0881b57550a0bb6d28de82a353365"
    sha256 cellar: :any,                 sonoma:        "8d8f20d021e55fb5d9be046b2544bc2305e82d36779b434de5745fbbc9c9d386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2a9bc608cdecaec6867a3a0450d86d87243745343385c7ce3eaac328c45e6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285075caa9a3c7a971379ebbcc2da942f13c9e21e2dcb258c9360d3d0d1776a5"
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
      cmake_minimum_required(VERSION 3.10)
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

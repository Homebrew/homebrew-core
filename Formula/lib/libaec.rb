class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.6/libaec-v1.1.6.tar.bz2"
  sha256 "41777c62cd109bee692a4976496ad680aa015016840b79ce2f84b8ac0d4d7dac"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d190d6d012003126a1eafb3dc218bb33eef869ae7bb8cca7e8637ac6f2cd703c"
    sha256 cellar: :any,                 arm64_sequoia: "01d7d32366e84925fe8d1bbbad28b614862298d88d8db4d6e540c030585c5753"
    sha256 cellar: :any,                 arm64_sonoma:  "8cc94718f5b8e9b4b2aba76a8a86f20d03519f0e35cfd6c8188be5141247d73b"
    sha256 cellar: :any,                 sonoma:        "f70bd70809d3884ac7992e8a145698ec6ab4987311a98b562a36bb56ddca9ba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b9577127b1597ba3be92bc0d7df3da1da4a040a79ffc0b0a56722385b11aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37c5777a53b8c787c337a8d6c199e5bd269166f7ebf325ad5b6ddfa3d6a7a10"
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

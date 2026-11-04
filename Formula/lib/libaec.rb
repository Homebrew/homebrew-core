class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://github.com/Deutsches-Klimarechenzentrum/libaec"
  url "https://github.com/Deutsches-Klimarechenzentrum/libaec/releases/download/v1.1.8/libaec-1.1.8.tar.gz"
  sha256 "660dc7cef65e1749a773439e39b25a7a6cee8f4c6d9739409dea037fac8ff4c7"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/Deutsches-Klimarechenzentrum/libaec.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "869b8090dd28b0c5222e43698ea3ec0c3abe0c321cc2f7689a7218bceb33d36d"
    sha256 cellar: :any, arm64_tahoe:       "250632689a82436e1ede76aeb877c96e311028102671aa3759966c11facfef0d"
    sha256 cellar: :any, arm64_sequoia:     "8613415289b9b15534e6096b2cae6efd8942bc83ce21db6fc3297362128d59af"
    sha256 cellar: :any, arm64_linux:       "626cae87583d70941205b4f7cc5b425ebee5747a3254a82c0c544915eb1fa009"
    sha256 cellar: :any, x86_64_linux:      "6d402bde6fee8e560813fca05f5733942d7b9bda27456df0478945f47b896b0c"
  end

  depends_on "cmake" => [:build, :test]

  # These may have been linked by `szip` before keg_only change
  link_overwrite "include/szlib.h"
  link_overwrite "lib/libsz.a"
  link_overwrite "lib/libsz.dylib"
  link_overwrite "lib/libsz.2.dylib"
  link_overwrite "lib/libsz.so"
  link_overwrite "lib/libsz.so.2"

  deny_network_access!

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

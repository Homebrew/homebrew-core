class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.4/libaec-v1.1.4.tar.bz2"
  sha256 "cf869c166656a83857adf62a092311a0069855c6ced3446e3f090a6d52279f65"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0510f8b013395583b6264196a1b65006a08bd66efdbdd52b6656a3e18f36b433"
    sha256 cellar: :any,                 arm64_sequoia: "16e420eafe09ff6630c42143074b87d3c4645e11eeb542f6fb859911673aaaea"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf3bea23c8ab8ffd2fe58c0dcfbbce362201ea3bff1037c940e6a2abb2728bc"
    sha256 cellar: :any,                 arm64_ventura: "728a90da56c97af9cb5228e08be60ea65363f01ad4b90a6b2d6ca88ef156a8c7"
    sha256 cellar: :any,                 sonoma:        "f30ea9156cebcdba5c55cdcb0318ce486cfa5df3078a3a4c7a986fb846f33ce1"
    sha256 cellar: :any,                 ventura:       "569bcd75e7aab19322fbfc28ff048c23013ac5eaa3c1bff470a1b19091e0ca56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "732f3679d8817c854204a734b3dfa37715b623623045f56046a6502a3606e4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44fc9841f59a6d54fc954ad713f19436dd16db17381034a732a346457d552b33"
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

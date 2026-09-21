class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://github.com/Deutsches-Klimarechenzentrum/libaec"
  url "https://github.com/Deutsches-Klimarechenzentrum/libaec/releases/download/v1.1.7/libaec-1.1.7.tar.gz"
  sha256 "cc7b93be9002e25a88b45d6b8d5f6120756cb5e1000613f91d803ce0beba24d9"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/Deutsches-Klimarechenzentrum/libaec.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "83059f1fc834d36e324b9622d003d7d1347de0cc33fe114d1c20bb95d0a37e9b"
    sha256 cellar: :any, arm64_tahoe:       "9eaed9136fb79d16e9e1d12d963079a9668f56317cde95d8775deeab37097915"
    sha256 cellar: :any, arm64_sequoia:     "c3be675b8a67f7765b62b1ffb2da781bf48a32e4b6a5986338e40b0ab919f9c5"
    sha256 cellar: :any, arm64_sonoma:      "9048d8800e5ccfc68e8832ebd7d0125f61792fefdd3ecd9c00cf0d50269e8893"
    sha256 cellar: :any, arm64_linux:       "13cf6eba906b53649ff511821667389ce65132e051e9da1a7c31c4b2de804149"
    sha256 cellar: :any, x86_64_linux:      "64bc329b09ee0597e68ef3521f09806c20e45eb286a2336efe4ed1603f570ec9"
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

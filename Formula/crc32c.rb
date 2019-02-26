class Crc32c < Formula
  desc "CRC32C implementation with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.0.7.tar.gz"
  sha256 "dddcf4b883eb08574b23b46baac5f6b0373343e21e6b45140ed1f46059fce1a7"
  head "https://github.com/google/crc32c.git"

  bottle do
    cellar :any
    sha256 "5d65f03fb8cd7aa5349daa78ac5d8a13a87dcd0e58edfdab98510be8d9569888" => :mojave
    sha256 "5a27559831f37f190ffef95e05fa093230c0ac3e46a17f33d18a775358edfd33" => :high_sierra
    sha256 "6c43bab5aed9edb9963dd6a92704291884d06472ac72550cdf4dcd9b49e6177e" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCRC32C_BUILD_TESTS=0", "-DCRC32C_BUILD_BENCHMARKS=0", "-DCRC32C_USE_GLOG=0", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DCRC32C_BUILD_TESTS=0", "-DCRC32C_BUILD_BENCHMARKS=0", "-DCRC32C_USE_GLOG=0", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <crc32c/crc32c.h>
      #include <cstdint>
      #include <string>

      int main()
      {
        std::uint32_t expected = 0xc99465aa;
        std::uint32_t result = crc32c::Crc32c(std::string("hello world"));
        assert(result == expected);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcrc32c", "-o", "test"
    system "./test"
  end
end

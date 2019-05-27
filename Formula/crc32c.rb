class Crc32c < Formula
  desc "CRC32C implementation with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.1.0.tar.gz"
  sha256 "49de137bf1c2eb6268d5122674f7dd1524b9148ba65c7b85c5ae4b9be104a25a"
  head "https://github.com/google/crc32c.git"

  bottle do
    cellar :any
    sha256 "280f1403560b15c47c7a329a3669c31a07fd79c4875cba6a5e9a1165ad20954a" => :mojave
    sha256 "6a23ba0acf485b27659e8e7058609551c218d6af53f583b0a911b6e8f3c5cde1" => :high_sierra
    sha256 "2dc0253cc78c964e53f91ac533a8f8c42b1516b94611f2de32270f6bb4193399" => :sierra
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

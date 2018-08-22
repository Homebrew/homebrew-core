class Crc32c < Formula
  desc "CRC32C implementation with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.0.5.tar.gz"
  sha256 "c2c0dcc8d155a6a56cc8d56bc1413e076aa32c35784f4d457831e8ccebd9260b"
  head "https://github.com/google/crc32c.git"

  bottle do
    cellar :any
    sha256 "e1ab3c185b52a211e7c19d00c2698514b29cb0250565718c50d8e8b309d21fe1" => :mojave
    sha256 "b700bbade7a8f06565f8e19cb724ccdf485bccc9a1dbd56acd7a0bb80670ef1f" => :high_sierra
    sha256 "35d06b0001644f7b697ba3df4b6a4d4f92d27277e311cb1438e348ca8f6a9ff2" => :sierra
    sha256 "6cff4648b0ac7455335437fe1b36b246f8d547dfbde77e32bf81494d47e6af6b" => :el_capitan
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

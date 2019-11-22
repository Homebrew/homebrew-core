class Crc32c < Formula
  desc "CRC32C implementation with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.1.0.tar.gz"
  sha256 "49de137bf1c2eb6268d5122674f7dd1524b9148ba65c7b85c5ae4b9be104a25a"
  head "https://github.com/google/crc32c.git"

  bottle do
    cellar :any
    sha256 "e2b5e57945365a1b21afdaf7e17e2ec43e1e5bf07b88486cf4df34a950c446cf" => :catalina
    sha256 "af325a8d3249cd237a34492d33c6c84cc7c058b9baede77e1499beb09789ee3d" => :mojave
    sha256 "bf99febb71f1928b3fddc01c509a53ad1e10d0f5ee64fb561b54729e8482465e" => :high_sierra
    sha256 "8f3c05aba98d9142e5fc1e38b1c0467f50dd6c51f03d53b0aa41566a8a7723f5" => :sierra
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

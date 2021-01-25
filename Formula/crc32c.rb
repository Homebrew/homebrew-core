class Crc32c < Formula
  desc "Implementation of CRC32C with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.1.1.tar.gz"
  sha256 "a6533f45b1670b5d59b38a514d82b09c6fb70cc1050467220216335e873074e8"
  license "BSD-3-Clause"
  head "https://github.com/google/crc32c.git"

  bottle do
    cellar :any
    sha256 "a37c7daabc55476ee3828211b32a63f052af9feeff1430fe53be9cef2038a069" => :big_sur
    sha256 "82e70741895a3e29dc0f8e48b0dd10e13e8cd380012457c1bf984ace3fd6dd03" => :arm64_big_sur
    sha256 "8ac4299583c3155c0410e246277214110bbbe453df5cc6b67694c67ba722bfbc" => :catalina
    sha256 "f5e232ed8a57eea6b226f4596f94281ea4ea5467c626e83a1576e74aee32711e" => :mojave
    sha256 "a8f21980c0fee7ffb9911b1eaa1bf7641940b4bb798a7dbd508ae60a6c1a46a8" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCRC32C_BUILD_TESTS=0",
                          "-DCRC32C_BUILD_BENCHMARKS=0", "-DCRC32C_USE_GLOG=0",
                         *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DCRC32C_BUILD_TESTS=0",
                         "-DCRC32C_BUILD_BENCHMARKS=0", "-DCRC32C_USE_GLOG=0",
                         *std_cmake_args
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

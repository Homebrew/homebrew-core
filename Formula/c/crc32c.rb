class Crc32c < Formula
  desc "Implementation of CRC32C with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.1.2.tar.gz"
  sha256 "ac07840513072b7fcebda6e821068aa04889018f24e10e46181068fb214d7e56"
  license "BSD-3-Clause"
  head "https://github.com/google/crc32c.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ada0a95e5f4b33f6a5caf7e56d9bfe608b44f01c7fd1be0db8f30d4102a473d"
    sha256 cellar: :any,                 arm64_monterey: "f36a8347a3c402b0f13b407fe0c99e1a2b067722cebf22f62a2f9916be2118fe"
    sha256 cellar: :any,                 arm64_big_sur:  "1e4ac6f8e18ad96c1d7b5e899902b6ce75d56953582066570de4ecc2329409a9"
    sha256 cellar: :any,                 ventura:        "838b9ec85a464004ec90f99348eaca5a2432de5ea2cd671d8bf454f5b4106612"
    sha256 cellar: :any,                 monterey:       "54317f1800ac7c165ada3b28a40c675e0848626901e654939e86966de36e4579"
    sha256 cellar: :any,                 big_sur:        "af7b55946ef4fb6f20e4ef31c77c0d23cc7e8e34861f8e96b367f801c611592b"
    sha256 cellar: :any,                 catalina:       "f4301aa03c705f8ab3fddd34090b30975306f4e159d32bd4f305dcac73914544"
    sha256 cellar: :any,                 mojave:         "7c59f41017496aa5997f0a43ca0b17f0676c665f782df0687e44fa542b9c0a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1d82ebed58e6c35064358c5a04428b6bb053413be7b11b2c14e4cbcd156205"
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

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcrc32c", "-std=c++11", "-o", "test"
    system "./test"
  end
end

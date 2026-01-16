class Crc32c < Formula
  desc "Implementation of CRC32C with CPU-specific acceleration"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/refs/tags/1.1.2.tar.gz"
  sha256 "ac07840513072b7fcebda6e821068aa04889018f24e10e46181068fb214d7e56"
  license "BSD-3-Clause"
  head "https://github.com/google/crc32c.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8e3aaa27057bb4e44a84d7fcdef9f8fea950c18d34017a3212f4f4ee9d0e6f03"
    sha256 cellar: :any,                 arm64_sequoia:  "8ea83fd9714095d17ddcb3b8a8f70d2c5694f35b7b6edc17aa8b32e6952295c8"
    sha256 cellar: :any,                 arm64_sonoma:   "df5ea233eee7c04d4c606c33132e5a769761ea6466f711832c22393ce0ce7170"
    sha256 cellar: :any,                 arm64_ventura:  "3ada0a95e5f4b33f6a5caf7e56d9bfe608b44f01c7fd1be0db8f30d4102a473d"
    sha256 cellar: :any,                 arm64_monterey: "f36a8347a3c402b0f13b407fe0c99e1a2b067722cebf22f62a2f9916be2118fe"
    sha256 cellar: :any,                 arm64_big_sur:  "1e4ac6f8e18ad96c1d7b5e899902b6ce75d56953582066570de4ecc2329409a9"
    sha256 cellar: :any,                 sonoma:         "9e3b13f21f27370340084fa45100b87ce3aa6a9f6fb403789683695958a33217"
    sha256 cellar: :any,                 ventura:        "838b9ec85a464004ec90f99348eaca5a2432de5ea2cd671d8bf454f5b4106612"
    sha256 cellar: :any,                 monterey:       "54317f1800ac7c165ada3b28a40c675e0848626901e654939e86966de36e4579"
    sha256 cellar: :any,                 big_sur:        "af7b55946ef4fb6f20e4ef31c77c0d23cc7e8e34861f8e96b367f801c611592b"
    sha256 cellar: :any,                 catalina:       "f4301aa03c705f8ab3fddd34090b30975306f4e159d32bd4f305dcac73914544"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7cd8632d65ac971ce60b6023b00c4f0058db967cc33dcaba57bfd8a0fb336934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1d82ebed58e6c35064358c5a04428b6bb053413be7b11b2c14e4cbcd156205"
  end

  depends_on "cmake" => :build

  def install
    # Backport support for CMake 4. Remove on the next release when inreplace fails
    # https://github.com/google/crc32c/commit/2bbb3be42e20a0e6c0f7b39dc07dc863d9ffbc07
    inreplace "CMakeLists.txt", /(cmake_minimum_required\(VERSION) 3\.1\)/, "\\1 3.16)" if build.stable?

    args = %w[
      -DCRC32C_BUILD_TESTS=0
      -DCRC32C_BUILD_BENCHMARKS=0
      -DCRC32C_USE_GLOG=0
    ]

    system "cmake", "-S", ".", "-B", "build-static", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    system "cmake", "--install", "build-static"

    system "cmake", "-S", ".", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcrc32c", "-std=c++11", "-o", "test"
    system "./test"
  end
end

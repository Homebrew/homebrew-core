class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.09.18.00/fizz-v2023.09.18.00.tar.gz"
  sha256 "002949ec9e57e2b205e43a7ca4e2acd8730923ad124dba8ecbe4c0dc44e4627b"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c502172bd801851e7f5a103b855024fe91cdfe6a2ed42952e6e6334888a67ba8"
    sha256 cellar: :any,                 arm64_ventura:  "12b618ce17f74443baa7fe2de5726e8389381005ed1794228d5107cef927272c"
    sha256 cellar: :any,                 arm64_monterey: "0ef2609b852428f2550241e1b3e88c5e1f74d72d030cd874fbc3347fcd06c1b2"
    sha256 cellar: :any,                 arm64_big_sur:  "b9544ad730e9a39b9c1d412ee63bbb329cdab5bb1cbe022fe9e2fe1fbffedd0b"
    sha256 cellar: :any,                 sonoma:         "30ad5ebd7247beee7f14c888e2ab20a055719de9ecac52e25595f60a8ab7930e"
    sha256 cellar: :any,                 ventura:        "1c67659b08824c9e095a5e42808fc308707b671704cc9dd4a4d98a027e732161"
    sha256 cellar: :any,                 monterey:       "ac7f5a5d07993d120da3f9c32cbbb74d6a0a222f50dbd3225893368dc78ba929"
    sha256 cellar: :any,                 big_sur:        "ab7628d67e3ebdcdd02ad35717c6842a8a3899d348ab2c4a20fae49226ac2ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584102ff2c001179d565db87c1f3936a96dcdae73b90d72c0afa9400a1dfcf41"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end

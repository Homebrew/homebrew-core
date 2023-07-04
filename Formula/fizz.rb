class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.07.03.00/fizz-v2023.07.03.00.tar.gz"
  sha256 "3f0c8ae30e6c78b5b66bc585e57a7d3ec12e5ac73bf09b3f3e8d1e13329b87cf"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fc9bd3933e55a58b2601b174c06fb5041b228d13b1701827f1a759320fa81ad7"
    sha256 cellar: :any,                 arm64_monterey: "60be7179d678738f15b61a2c21cc162e0b489d642acd9a84165061add361959d"
    sha256 cellar: :any,                 arm64_big_sur:  "b4e82b89aed327055c2371e02c93658cdbe545cf6215c5d35ec91835cc0d64e5"
    sha256 cellar: :any,                 ventura:        "a60a7a613170ef1d45f320001858262ffe77a31fe6e5d29dc523d08737ed02c9"
    sha256 cellar: :any,                 monterey:       "915f56748a1bb9b3bcf0bd57aba969d1e8aafe427c4daf131815df15687a198b"
    sha256 cellar: :any,                 big_sur:        "16b6da4b020eef7b6c25618ffe01f646d8efb6ed4bfb73b1174e7fa6eae32c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7737d2a148f020b18497a20e8b935fe6c7d31514833b4f2c910c3366f3d5f84b"
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

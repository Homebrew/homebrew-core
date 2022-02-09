class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.02.07.00/fizz-v2022.02.07.00.tar.gz"
  sha256 "59faf6e0c74cabe270f9face13e0a9aa3b1c6b6abb15bdedabc8fd21afcdfbab"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "837f5871b462ef67a58781f208c068e2ee6688bf9c05a7c48e2e3052ef95135c"
    sha256 cellar: :any,                 arm64_big_sur:  "3bbc676c7bc91501366549aa956a4b4aee91ca6b1c1e858abf89939a00917576"
    sha256 cellar: :any,                 monterey:       "c5f807d77ca299474f2b6c7f88cdcf487000e9440a6b4d226bca00f767bc4581"
    sha256 cellar: :any,                 big_sur:        "332869552ae1db5a65cb3fb550da462f8083f365b905493843d561ec55aafd2a"
    sha256 cellar: :any,                 catalina:       "82426cc7d3df0bf95db5431f03ffd58cc2cacfdb4e42ddb9920a9087f5a4fb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e589480ece02df7afa36eab8fdfdf7abd28aebac280df383836ba982e80988df"
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
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []
    args << "-DLIBRT_LIBRARY=/usr/lib/x86_64-linux-gnu/librt.so" if OS.linux?

    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.01.31.00/fizz-v2022.01.31.00.tar.gz"
  sha256 "32a60e78d41ea2682ce7e5d741b964f0ea83642656e42d4fea90c0936d6d0c7d"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a0405e8b9bec1a48250b6a8c716173af9cd47e0ff68098beddcfceff21672ca"
    sha256 cellar: :any,                 arm64_big_sur:  "77df820fc0b7ea82201ec56a7adeac4e98f42d1fc7dc3e6bb25e0f825bfc1c26"
    sha256 cellar: :any,                 monterey:       "885a04eabfa4c6ad3dd5dbee2b88beff8d99cb14cf08b5b213a2944e653d7eea"
    sha256 cellar: :any,                 big_sur:        "3c10c20929315241b39259feb54b0798186ae8cbb3f99d08a280873138de9c12"
    sha256 cellar: :any,                 catalina:       "27ab1902a718915d826a7f6b026d441aac9173ec8638fef2c1642ce95b3adf9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3effb0ee10d84b6505a1160e909ef568f85641123a4582f4ff2429d9a64e4f5d"
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

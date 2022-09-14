class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.09.12.00/fizz-v2022.09.12.00.tar.gz"
  sha256 "19b7e5f330b8b5b99662dadb151ffe82c2cb439a2253c9b3f567110b774e9a30"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c6218227193c9d907f4f834e32885667336c16cc47e4653ee4a19e8ca576fbf6"
    sha256 cellar: :any,                 arm64_big_sur:  "3e1f1c338690ff60a15b35e7f68fbe0f31a5f8c44aa3ae86da22925854945a30"
    sha256 cellar: :any,                 monterey:       "954270622541a3a3a3ddccf3b045d79300b9d63a5dfd66bae5eb43695f6a6cd8"
    sha256 cellar: :any,                 big_sur:        "86552720680fcb00cfeccb390e4b10ce27546c1e1286764ad3bb26bbf3fca4cb"
    sha256 cellar: :any,                 catalina:       "e9b15849b581258ac8cfa7c63077d20300147ca4603b072d79baa8e7f9176b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e3e9400904c5f283c3aa3cd8276ac0c939106f946c3c45e700954bb9f705ac6"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.03.21.00/fizz-v2022.03.21.00.tar.gz"
  sha256 "b2bb1f303ecb801ef691f8e63aea861d36ccfe17e6bdaa8160748639be6141b9"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f53bbb4d60c507d58a9b519e09b4cef7f914b7faf3bbb7bc4bfafb9e84b1af04"
    sha256 cellar: :any,                 arm64_big_sur:  "4d13c2ffa8b20e899ea3f543c7918ac39933cdba38c0299b44302d8ca0854111"
    sha256 cellar: :any,                 monterey:       "c1565e1eeb53b8690707898cbc72de61f1a72ca56115f51cce9504dc19cf14c4"
    sha256 cellar: :any,                 big_sur:        "1f31d32b0f08587aaaee72d6f96ad03adf485bac7d885f6b6cd1602582bc7066"
    sha256 cellar: :any,                 catalina:       "257d64dd835801dd974206b6307e8e22fd691b2dcfc508af5b76b00642481c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15c4408a3caa4b37ebefc0f6a97cd6a640120ea38b26e904c5a4951404ef6ca3"
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

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
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

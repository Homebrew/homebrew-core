class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.03.14.00/fizz-v2022.03.14.00.tar.gz"
  sha256 "10fe63db9ac8ee06723d1aa95101f0f156a8db677a729170bca0bab12f1cc279"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "01cf2376c78dcfd6c07df541edc4d44f7d00746f2c20a8d2f15107c34e6b40ef"
    sha256 cellar: :any,                 arm64_big_sur:  "25d28319e2e09a4cb4d2f68073e3c98057965af89cd838c7b48245d1342ba057"
    sha256 cellar: :any,                 monterey:       "9ad988c9eff4f1a43160823b5ebf2ba43a149f1c1e0f8534f487bb8d4ffdfe09"
    sha256 cellar: :any,                 big_sur:        "9b725634992a85b48237dcdcb2ec22a9c8cc444de546abc1234a03278edf52fa"
    sha256 cellar: :any,                 catalina:       "50ad01077d62976ad2afe0d0518e280c37142c8a105d020fffa058316f8143c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be93097dc8e7dedae39fb363795c1d3bfa479a9bcee233a2690c20bb12fd27b"
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

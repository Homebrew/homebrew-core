class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.06.06.00/fizz-v2022.06.06.00.tar.gz"
  sha256 "67dc74d0b93d9fb1b5c79b1b12e0b7ba4b6df11eb231cdd3a9dd8d0523703b47"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f7d538e2fde4fd005e38b80c4db4fbfa982fd1917a600ac3bcbebdaab83c741"
    sha256 cellar: :any,                 arm64_big_sur:  "1076f2898105bcafda0d65d7c2d4cb080e328787e20a5293b6f8fcdc6ddd6b89"
    sha256 cellar: :any,                 monterey:       "ab7a7b301060c7a11ae62cb65a732e9d60a2cae1a1d323ab15b217867a46aaeb"
    sha256 cellar: :any,                 big_sur:        "c12b210a8924552299f438ed74a10ad857cffecaed3c038d0aea7871001481b4"
    sha256 cellar: :any,                 catalina:       "884d81652caf9ec99d7c2f55d37f93ca2bb38c842ced242262b2ff335d07acd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249da5e23a121ce2547459de72491712d1fc33ba6745681704bb3b0ac274771d"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.01.02.00/fizz-v2023.01.02.00.tar.gz"
  sha256 "12b6cab53fee357765603ab468517a0d9c92ff171e5826e2c4a2d41a7444933b"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f51967beb8b3d42484fe49e97f052857c654f3f061968ec232aaac1962b2345"
    sha256 cellar: :any,                 arm64_monterey: "69e4661b77ded20e60fffe4af5292dcb6d24a4969e9d8e11303bc054c6d661d3"
    sha256 cellar: :any,                 arm64_big_sur:  "ed929d068c3664fc04ae9362acda4313012a043f1d152944b8acf60388450f34"
    sha256 cellar: :any,                 ventura:        "d6423cdecd1486ccdd0a4fa9de39bd6d688998d33a895751ba6649baa9e88596"
    sha256 cellar: :any,                 monterey:       "1836458bdda141664656a9725470bce6722e1102e37eede30faf8688686903d7"
    sha256 cellar: :any,                 big_sur:        "30c57e3403e2c5b6f645e8a0e33ba753182b9ea9730eb4000406cf08f08b5a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff60a28a46ce059045d884e95520db1838f566395564c69e8b65089208f1f1a1"
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

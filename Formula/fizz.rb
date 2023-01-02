class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.01.02.00/fizz-v2023.01.02.00.tar.gz"
  sha256 "12b6cab53fee357765603ab468517a0d9c92ff171e5826e2c4a2d41a7444933b"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18ce40827c753fae57c6402f37b2367bcdb12afd7e334abf4402caec59e68378"
    sha256 cellar: :any,                 arm64_monterey: "2b3e9e61779619e92fdb143155c69c8d6dd18612009525f0bae43574435b4d4a"
    sha256 cellar: :any,                 arm64_big_sur:  "9a826e37508bd4498bdbffda337655523cf1fba0fbe711e181d17ee57c4de6e9"
    sha256 cellar: :any,                 ventura:        "82917d8c0fb92b7622b75b7ff3060ada44cb113bce65a768d4145c099df421a1"
    sha256 cellar: :any,                 monterey:       "c402a5e4eeb2e1d9c2f430dbd0027129223892b89cce8ba7a852e39722ecba6b"
    sha256 cellar: :any,                 big_sur:        "63ac46c7330a237488773bbca2b213b305af3fcf3e85bdca3c50a666084d11f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b668ee9e3037ca974a687d012b0dcfae3f19320a2545a13ec547da03b0c9e057"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.04.17.00/fizz-v2023.04.17.00.tar.gz"
  sha256 "75119b962a7252de6ece690f53db4742802d12d997177085426f284cf5c52617"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97f30759b7be4c0c6328796596cbad1ee9cca92ab360a07c1d9599012e109d52"
    sha256 cellar: :any,                 arm64_monterey: "dce57f9a3bce437e2ab4caf918653bc5975a7b5978740893daa39318a8b30ef4"
    sha256 cellar: :any,                 arm64_big_sur:  "32af5a0dc63b2d15d2ea606db3e481f6ad750bbb6e3f4c7a53918533477e456a"
    sha256 cellar: :any,                 ventura:        "d85b14d46399e8f0079d035274fce157ef42e4c885500f85066f61e9fcff5241"
    sha256 cellar: :any,                 monterey:       "42262c623d77e7986ddc7c2d605f86cba5ff325181e397e710bffb2f3c90f5d4"
    sha256 cellar: :any,                 big_sur:        "974d1490ff6fde136ac051d6eca1172fac93b753c11ce04cf6a85a962363ca38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12f70d2ef1fd8433f35caecd88ebb01b0ba1ac391076d8312a46a38084bf3c6"
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

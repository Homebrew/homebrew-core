class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.08.14.00/fizz-v2023.08.14.00.tar.gz"
  sha256 "d60b621e2cc95f86219c13852e76e0e8bfc84a3b9648426647496e96364d4f1a"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7fc38349aed3276fe8b242baa48c672c405a78b20334f489eb574d41217fd7cb"
    sha256 cellar: :any,                 arm64_monterey: "aad53fc356bf6b509efec939b444a5e3bef74fc3fab545a22a5cfee05d78c324"
    sha256 cellar: :any,                 arm64_big_sur:  "46238fad734f8b557cfc6e974916aae5056783f1d21ae079764ab6feae8b9b20"
    sha256 cellar: :any,                 ventura:        "7c66527708cc982967af8cc315b575a161a422f8f8a4588ade66bdd7f68d66a5"
    sha256 cellar: :any,                 monterey:       "320472ced313d4650db4ca9787bbb5af691b147d88d8853fc87e92c05fd4e064"
    sha256 cellar: :any,                 big_sur:        "f9cea70444ae5b22efb396ae4fcea0955b62af473ffa3231aa69050cbc42eada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe62747cb51a865dc1328135fc7beeb424f44ce4abec62de94c1028cb8a1b36"
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

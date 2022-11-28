class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.11.28.00/fizz-v2022.11.28.00.tar.gz"
  sha256 "bc9ea4256252b31bfa6b2421d1772c699db5d349fe1c350aa6c99d9da260edcd"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dc951aff60008f39af761ac73f145a5ccbaf90ea8d742517fb943bc02b78a97"
    sha256 cellar: :any,                 arm64_monterey: "36c63a2965779dee50bba37d3cdacbfee47ca7a225e6ddb398d00b02eae81a6b"
    sha256 cellar: :any,                 arm64_big_sur:  "fa723c447da340101e9f672a73446adc4612a38e3cf9ed254d2e54a95d9ea996"
    sha256 cellar: :any,                 ventura:        "5b2332e9b13b9a2e5651c8ffa72d88e73af063a041569ffd684c023bb864e526"
    sha256 cellar: :any,                 monterey:       "de1dbe82a8a0abb67ff3b33d87a696c7bf9c6a6956a0f72807c5de794892dd2b"
    sha256 cellar: :any,                 big_sur:        "9b290993f962e6a475d57495da549f2ca165dadc9b8a86d91f3827dd0eb6ad5d"
    sha256 cellar: :any,                 catalina:       "a6539634f48d141ac5ab373ac5536feeb1a60507717f4f478728f926b6aeb507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae6a79c496e3590926f57ab74972904fd64fe3826613365e2cb2e6d6d7f046f7"
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

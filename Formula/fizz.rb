class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.03.13.00/fizz-v2023.03.13.00.tar.gz"
  sha256 "54d91581da093d70cc0baf2a391c0bd64b6015dc70c90c1111c2a4d40240f5f7"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f51ee192b0d036b9028cb4c01508616695d16a6cce63c07f55e8d75ebae5ab8"
    sha256 cellar: :any,                 arm64_monterey: "a1fcf3135da0c44e1c8cc89d199dacc58c97bd7c49569ae2bcfa8a01aed33643"
    sha256 cellar: :any,                 arm64_big_sur:  "59aeec7f149d6d5e885397def5922123cdf82c0a583ac7c40cac2f2cc41d252c"
    sha256 cellar: :any,                 ventura:        "832b99e43d132f87935cda19972848e3fb34549f8d78e891f4c26badf3b957c9"
    sha256 cellar: :any,                 monterey:       "9ce8f1689cf515987fe615c55f6b256e045d12bba75cf7edc1a4ccf91a6e22a8"
    sha256 cellar: :any,                 big_sur:        "a1d2d43c842a153e22d15dceb89cec1fa555fa6f31995be9257b32aa801a68d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66735890605d31f77aaa52d398d79701cfbc28827032ad40371594858192bfd3"
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

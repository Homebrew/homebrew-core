class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.03.18.00/fizz-v2024.03.18.00.tar.gz"
  sha256 "2d16ee9dcb2069394be15e4bca0d97e15b4d20262440a9a5884ac568bae1d054"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1a4d2104c0046c0646eadd94642782eaf359a443ccd77f5afe92081e21356f14"
    sha256 cellar: :any,                 arm64_ventura:  "1ee92bd08b3bd1ad282dc39302296d8e3608221b25da03daa230f4720d3d66a3"
    sha256 cellar: :any,                 arm64_monterey: "33dc74f95ddc4f71b8364e7d9b333708f23dc4b357242bc6d30c606b55e21390"
    sha256 cellar: :any,                 sonoma:         "96c0aa5bc4df042280532ff69623575a9fe865c4f28ac65b85ac679524876896"
    sha256 cellar: :any,                 ventura:        "384a886d77010637b0b57a670fb7dfb299b66e0915ee96037646f56f3d6fdc7a"
    sha256 cellar: :any,                 monterey:       "7cc50b681b3f5d8f08f1f83928e36da7786338664f969da2fefad75e3febda4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78a433b752b6b68bf39fd73fdea4986c85699bf7dd9450bcc75aec43b256454"
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

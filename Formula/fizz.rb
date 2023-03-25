class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.03.20.00/fizz-v2023.03.20.00.tar.gz"
  sha256 "79a43e7b16b890fd11a9dbb098bda0440c5c6915a4cae59e1dd89bb2ff7e9aa0"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea83611f29f8535f0c6d10b26242e0b18e95f917cbe98c9a687a21b8f1fca69b"
    sha256 cellar: :any,                 arm64_monterey: "2c9908f6927a7f81fb9faed333244b1bc6468b5ce064731e807f38e3fb8c2e6c"
    sha256 cellar: :any,                 arm64_big_sur:  "82a0097fbca2801ec237fc095f1db65bc75ed3062fa7c061a0414e4b4c454162"
    sha256 cellar: :any,                 ventura:        "feae2838ff0ae557d5f8173f2bce7c2e46b994d019a045ce486629caf83c4e38"
    sha256 cellar: :any,                 monterey:       "f3bdee23ddff901817d4159f20916e4d3223f90fdee89ad2f9debdb39e755c00"
    sha256 cellar: :any,                 big_sur:        "c82c6dea67316d55b4f9e0a3b0dcc5e67c179c156daf2225b79562d6fccf606b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca980b0ba44891fc43d23f534454019dd596b28e520920ca2556d77756a5f1a"
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

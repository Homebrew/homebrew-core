class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.04.29.00/fizz-v2024.04.29.00.tar.gz"
  sha256 "b07e3097bf96353d85081a2e0bf9f5f1950a3d7c9579918d65aaebdd18da13c2"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98635d1f651d822f37cef407db81539b881c9f04fbe460771c3d6486fdf223a2"
    sha256 cellar: :any,                 arm64_ventura:  "d519477ed5f7459474066fd2e75409b074c5bc024e30bf6412cb2f1026904326"
    sha256 cellar: :any,                 arm64_monterey: "c335f0a75062a70105c8459ac3814bb7a9310e46334de501ae36e6629830ec66"
    sha256 cellar: :any,                 sonoma:         "3330b672feab896ef962c30faa0bed9ab4473d7b7f411a833d0a594428ccee7b"
    sha256 cellar: :any,                 ventura:        "6d481fc1d69c227b030b243ac9daff3c8ad60b9b0c644c687e73098411971245"
    sha256 cellar: :any,                 monterey:       "315c2151f43a9e191367d9dcb647af853c9bcd4d1c27012fb727a8b96cd653f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "007c382d2175a385bcc859dbbb421c161800aae561fd11851389ab79888debe6"
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

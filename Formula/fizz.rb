class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.05.08.00/fizz-v2023.05.08.00.tar.gz"
  sha256 "754263ad2bc60fc48c94c7bfa5c25b9b7af8424cf164be3579fb5e74479e7adb"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "082af4996153ed73157e99ee0ff8a6a717c271e7c42fcab1e21efb0d485ac4b8"
    sha256 cellar: :any,                 arm64_monterey: "ed37f514f7441b9d6d172ffbc9702544950972e07e0997336e37d6657bad4d5e"
    sha256 cellar: :any,                 arm64_big_sur:  "c65ca07b418462d7843f9db8d07a7da4be99be2605e85e261adbeeadb246ed00"
    sha256 cellar: :any,                 ventura:        "a0c8c96ce7ef82a9c76c4f18fc222b670aa5ef21dadaa77cfcf3eb34ac2339fd"
    sha256 cellar: :any,                 monterey:       "6757d732b29d641d82c99ebed1b5c237e882bbe376db5af132b201b6494bdc4b"
    sha256 cellar: :any,                 big_sur:        "7e80ab1d537677a87bcd630e5b1ef7796cb4067ff904e5a0f82ddea5da9078c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de192e94dc4631d9a5f3bdba619fe657a8764890b3af1838a04ea4a4d2f894e"
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

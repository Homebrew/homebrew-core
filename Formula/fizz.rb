class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.05.30.00/fizz-v2022.05.30.00.tar.gz"
  sha256 "cbe82c714578e71315c37212be3cce811ac170e7f6bcbef802b27acaeeb624eb"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6496c541a485bf30092dc186fb0851ec717ca6a48600e139d869ef85689c8e05"
    sha256 cellar: :any,                 arm64_big_sur:  "738e4a9c0a18f6ef4a0d973c14fa2e1bbb64f77e13c8e8b1c25fa80164d7fb07"
    sha256 cellar: :any,                 monterey:       "fb66b6ac24baff42d7695d58aabce506162b4428e08a1f101125722c1bcc899f"
    sha256 cellar: :any,                 big_sur:        "0344cbe20d1520dc4faff5b9c7ef1073abf301d8862c8e2533d636a08d56c5d9"
    sha256 cellar: :any,                 catalina:       "cf7a4955005fd9e06d587bb9cccc38e36ed35a6b0bea5fa4616acc9c3e6767bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d08370820da040ae1e60eb34dbd7571f1f044b20c3dd1952ebda376ef975b4b9"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []
    args << "-DLIBRT_LIBRARY=/usr/lib/x86_64-linux-gnu/librt.so" if OS.linux?

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
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

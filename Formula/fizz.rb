class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.11.08.00/fizz-v2021.11.08.00.tar.gz"
  sha256 "96d1e37086e9ce5dc997d39d5aa5590e0ff587c1cd9641337fb655b9a934c2cc"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b2dcc4e36d506bde82d5d5dfbf0a27249fc9643f2eff3368579c51857c6c1b7"
    sha256 cellar: :any,                 arm64_big_sur:  "a08a6754adacb02c28d76ea85cd922dc0467011b3de734699df9ab11e918f2a5"
    sha256 cellar: :any,                 monterey:       "7b0f2ebed599d8c8672132db606b93738f8f467f10eab9d4859c536733c40986"
    sha256 cellar: :any,                 big_sur:        "537361dcd8b2f886cf8cf0be65c026f5b1a96dc1e2f4c08fda18a0cd34fe39fd"
    sha256 cellar: :any,                 catalina:       "1d000821f1b6ffc12511dc8be50a58b25461618c38477f27633aa3eebaa80845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1b0fbb8e18b49901267b513ea523cb5aad671c80eaa07115bcd179356f176c"
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

    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
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

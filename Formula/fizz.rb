class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.01.24.00/fizz-v2022.01.24.00.tar.gz"
  sha256 "3d57158e2a20a545dc720bff02a9cc53924f2c06a21a7656c1388d2639dcd903"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "580857cf03210ac0c5997f56a64c1fe983a81a768ca414baa55145c9f2161430"
    sha256 cellar: :any,                 arm64_big_sur:  "c28d2a043bba00e67397d155972ad9e432c750876cfa13e3d25ed5988fbf9131"
    sha256 cellar: :any,                 monterey:       "940f854b564a0a4c9d39b29072f391c8594322380a0d6adf0cc93c7385ea24f4"
    sha256 cellar: :any,                 big_sur:        "8cd062919d7a75d01efa8306d85d3ef316b81b659b318d631375121dbe9f79cc"
    sha256 cellar: :any,                 catalina:       "c25f335567e438acc02c224b2418deca599312ce749725b6b290234fc9e8fb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d07955bc1d5d50e3ebd442be13d207a1b6aa02a94cc5300591679db7938801"
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

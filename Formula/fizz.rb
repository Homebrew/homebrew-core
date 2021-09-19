class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.09.13.00/fizz-v2021.09.13.00.tar.gz"
  sha256 "47630a44f4d66ae0a5a65fe6b215bb02649a70aa1e5f92f747ffefde46834135"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0f91cf2db9b57b81bcab88795c4877bc311edea7e56549a42e12fd6c3896f28f"
    sha256 cellar: :any,                 big_sur:       "9a3c4042141600b6155dc07299b3945a7c57bc7accb52751806b19ff4867cfaa"
    sha256 cellar: :any,                 catalina:      "bbcb103edb1ade2ef505860d5d9c51a674d40cfc1b66638038461245e2025e95"
    sha256 cellar: :any,                 mojave:        "bc8c4054ecec468d8a9350303b12486349651049206d884976c797d93b8f7b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369f8366165e6d2b2e6323c8c29b7a5a12e1d0f8a80143fb9c0198dbed18e158"
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

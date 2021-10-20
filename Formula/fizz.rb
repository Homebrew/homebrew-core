class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.10.18.00/fizz-v2021.10.18.00.tar.gz"
  sha256 "7e0fa33a8329e692f23309a331f4fe3a6d698a9a1cdfdee634293a6d40fe7724"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5fe44b53a229bfb2000399ee814dadb6beca3d3f6652fb376afd498eeacc1e76"
    sha256 cellar: :any,                 big_sur:       "c0267ccba84193c71df99ef067cc2da5611c4cf3f0d059928d63d575ba887429"
    sha256 cellar: :any,                 catalina:      "9b74bc151b2998ad287d80b5666417c92faffaf8424e2e7b3d7326787e216a39"
    sha256 cellar: :any,                 mojave:        "05eccb9eee0edbfaf1cf20d0cdc910c9b738bbcf8a6b97006b0ba85d67587a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb60ab0574bd1f28e538b5cc49f73d3132a4a90cec04b58e557f5583ffc1a05"
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

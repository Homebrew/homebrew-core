class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.07.04.00/fizz-v2022.07.04.00.tar.gz"
  sha256 "48941c3726b99aa9b22480ff92cbe3715154df0a4330ad42485b3d7649167b76"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bfc5bccc23bfd2672d2cb09f600e890feab4258b31b7110ec1b11a1867e336d6"
    sha256 cellar: :any,                 arm64_big_sur:  "2c0d15b0d02984c5dc5e84a732a77c6e558922e5b8c778ba0796759a495757c1"
    sha256 cellar: :any,                 monterey:       "c3721df752c4cd035252695f12daf9d6a0ed1f7d6d55d2d773bf8333c961fec1"
    sha256 cellar: :any,                 big_sur:        "11665d007c7aa7a19ebe9acea99f3d7b47bf28e39cd3dddf4084b91e69ad1dad"
    sha256 cellar: :any,                 catalina:       "8e7dd8d5d27f64ac4782db51ca87a07ef512be33333307770e7032ae40e69d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24de05b2425244bdf8ebdc4c4187b6c3f8022fa8266098c202e5997efa2993c8"
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

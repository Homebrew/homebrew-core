class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.05.23.00/fizz-v2022.05.23.00.tar.gz"
  sha256 "b51788d2dd0639c8be1716b9a012c5b64e9a8fae59240b917318f998a7a28ef7"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29a6171d1bbbf1571937dd83f049785d353d2385c1775221a474cf9aaac45041"
    sha256 cellar: :any,                 arm64_big_sur:  "d8a8c5fdad7a772d7e49c6205201255af3ebb650f856ff493f603b32736abceb"
    sha256 cellar: :any,                 monterey:       "40f8b322746b3ba88c7a5a66217d388cf754a9d43adb5116e689947edd4a6919"
    sha256 cellar: :any,                 big_sur:        "d96e9bbcf4ce0b6447233329ffcc2ce0f966f78ac5a8877423aad6f70196737c"
    sha256 cellar: :any,                 catalina:       "1b61afb959e063d6318147f8ed2221108dfe5ee3cc1d626b24119da1543d8893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4bd036f1d575b4e7bfb25436c268475e1be6d649c4f068ad4b06d7f108ca4b"
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

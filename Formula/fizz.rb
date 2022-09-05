class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.09.05.00/fizz-v2022.09.05.00.tar.gz"
  sha256 "38bc2512f8556b98e2c94c220c27b8bc4d551ffdc4d67d84b538fb6ab3fed4d4"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7418e55de606c8c7b9bdab053d689651a5bfe9ee8f63e85d147a0bbeea000a0"
    sha256 cellar: :any,                 arm64_big_sur:  "9d9c505fe8d25cc692d7ff8b3f801cb34446413027fdbcc8a8563b47e69ab8d0"
    sha256 cellar: :any,                 monterey:       "43099f7531d923d8ebd0d59547a6950adf8acf721d75d2705054ae4ff09f4bf9"
    sha256 cellar: :any,                 big_sur:        "25d8f787be0a900f07335bfd7517a933d59ed72424624a0b6453b603901a7085"
    sha256 cellar: :any,                 catalina:       "7c0599a785a7b23123bc07c01ad80a1da9faa311662bcc6b07b74f293e485348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae0e65cd42968f75abbf5d4a8dc79dcbf52618c4e057d0806da3238d2148789e"
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

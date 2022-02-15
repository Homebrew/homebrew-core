class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.02.14.00/fizz-v2022.02.14.00.tar.gz"
  sha256 "7b5d4a00d551b5b0b610ac8a69e69283e4d700838cf0ab64f606b35478a08d42"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9408e97f446c1925fd0543dc4adb8f9eb3cb8c588f61994133fd043c8ba543f4"
    sha256 cellar: :any,                 arm64_big_sur:  "d09602a6e5ff9b43a0306a78a828706d152cf705eb56c94933b2be2ed7134a09"
    sha256 cellar: :any,                 monterey:       "d8a37442514952a55a98c3cb7052a337781c5f635659bd5d79d4938138d18184"
    sha256 cellar: :any,                 big_sur:        "e0342c9f6e98737f9edcf0b88666e46fced705528d5e85b7d96de339ac124311"
    sha256 cellar: :any,                 catalina:       "41aaf97b4bdc4b5147d8cb42c44622da972ad8a2934de8faf46da37e17b944eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "432a44d494c13331f55e286bdeeaa4e6cdbbca5a8c322f2d746ebd4f6e816322"
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

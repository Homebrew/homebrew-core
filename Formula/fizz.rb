class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.09.06.00/fizz-v2021.09.06.00.tar.gz"
  sha256 "cb8481ac7ca56a8cb4acfabba66e0bc5aaa5ceae04d5dcc31f1b88aa2e0cf93c"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "96a8a65f606da04ed34d8e2ec4a04eda20bbc2bec7b81d4828b76e473d0ad619"
    sha256 cellar: :any,                 big_sur:       "71637ebe563e566e6ad66b43b1e61549b13fd734ea46ee44f8d547fa36f62e47"
    sha256 cellar: :any,                 catalina:      "a7a00effdcae1e9ff827e7eb961cd2d20f3ec40ee4e270345a1d22502c5c4a04"
    sha256 cellar: :any,                 mojave:        "d58a8fe639946b509161a7a1cc205184b3e36cd9b12e9aed11cdc2d7dbbcac0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e616f1d0a2966e61d124867770ac5a5d9b14dcd82d16de052310b37bfdcdb6c4"
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
    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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

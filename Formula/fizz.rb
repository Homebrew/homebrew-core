class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.09.06.00/fizz-v2021.09.06.00.tar.gz"
  sha256 "cb8481ac7ca56a8cb4acfabba66e0bc5aaa5ceae04d5dcc31f1b88aa2e0cf93c"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f27eea8b727899dfa3c7e1789245960288f0b9cd3ef86b075b172b8b2659a55c"
    sha256 cellar: :any,                 big_sur:       "6c02e9fdc400e5e0bd649334b850138940979e09d545640a8a9e1bc507ea011e"
    sha256 cellar: :any,                 catalina:      "38f81411c134be988f02f4a20c79d55ce750e6c93b3695e91fa5ef8550abe726"
    sha256 cellar: :any,                 mojave:        "499878f5f79b0fcae7cd95e09a1877898e8e26da4f4b56467bc937696a3f4a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99e20d580bd3bf5f2b70aec84d5fd060be24b5f0a0c2be9b0fa0271fd2212ac"
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

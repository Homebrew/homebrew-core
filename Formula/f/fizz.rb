class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.09.04.00/fizz-v2023.09.04.00.tar.gz"
  sha256 "5988e2294f5d786f937af39b3f9d0028ee1b4d410d705f172c9b0e952fa404a4"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d63c9c58dc2dd2cf9535c0cdb412da451ca82389fd295243d14cc93194164f88"
    sha256 cellar: :any,                 arm64_monterey: "67a992162d4861b2edf2cffb4c52ad20e09db4b646f9f872cf84f4272480af34"
    sha256 cellar: :any,                 arm64_big_sur:  "a2a3df42e363d8be776cd339cbf15344fbd2c64be34627aa8e0c03a1f2ca525f"
    sha256 cellar: :any,                 ventura:        "e7b81a0611c5118ca373b2006ce8e0ee3f52981e3e92867e80eef56bfdbe5fda"
    sha256 cellar: :any,                 monterey:       "8ac3463a642c458a6d5003a9f8e4ab0f17d6ada41662f0761b8e9734dd23ed99"
    sha256 cellar: :any,                 big_sur:        "308d921cb099733535fe6896859736d3fbca5e85812cffc403e1884ddf63bcd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed02955c9f4a0f527ffbf3f91e361c5468355817ab81685cf799b649a1c9f59d"
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
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end

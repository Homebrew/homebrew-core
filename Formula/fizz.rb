class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.09.26.00/fizz-v2022.09.26.00.tar.gz"
  sha256 "d1907c211f0bccd4125d18fa6536bcc6169103de8920ef669995183493fe879b"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34e9b8f66261a7b6c58234d967356eed7ab5c0bfcefbba3ec3491905b1535dc0"
    sha256 cellar: :any,                 arm64_big_sur:  "42e98336794d782757e8d435a312457b391986945e5e2adb4f29e19c89e9b7a7"
    sha256 cellar: :any,                 monterey:       "fd8b0963e34c39c97957ec28b02f578ebf261b4cd11d628f220bd9b6e51b39cb"
    sha256 cellar: :any,                 big_sur:        "f08f01cff84da3f468be320effff12c80340bfe2224471315e79271845e5641e"
    sha256 cellar: :any,                 catalina:       "d5433be279b242d589d63de05dcfb29e39c553ecaae029b8067da3885ee2261a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "203acfdfbb08f6388381451c929db963cd6cda678a1259e34cd4bbf8593ed18d"
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

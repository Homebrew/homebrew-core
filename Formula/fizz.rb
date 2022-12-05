class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.12.05.00/fizz-v2022.12.05.00.tar.gz"
  sha256 "460b28f2dec6b3cca2bfe5d9ecddc8ff5b0adf9d2d6dac92b1f45244d6d104b7"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "163b3f376d7d2e261f8913fc80d7373dcdccd2732aadd22a80310671ad151736"
    sha256 cellar: :any,                 arm64_monterey: "bb84e7fd98872ffd921828cdbba5f8f47b318750e4c10fd283968699380692f8"
    sha256 cellar: :any,                 arm64_big_sur:  "fbdd7fb0f87307caccac3f1c4d721a2365dee989d1a33b19c99535ddd7f3fc0b"
    sha256 cellar: :any,                 ventura:        "97cd623a6b24bb68e13e369aba9a4d8793a3805ebed2daa93204620da9414c82"
    sha256 cellar: :any,                 monterey:       "18d171093ef3549ee2389f38329ee459fbd9e20079bbbe3cf405a7763eb237d7"
    sha256 cellar: :any,                 big_sur:        "cca1d383132e98b88db1e053a8f84d652d702940d0254e6264ff90f342ef453b"
    sha256 cellar: :any,                 catalina:       "7c75e520f85c167bfe1e65b051a82e77d51bec099051c3e78688f482c6d57cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67347fc16e88bc44747f303ee8be964aa255f9b5f5f0e81a7aa38dc5b4465a79"
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

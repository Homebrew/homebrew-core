class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.12.19.00/fizz-v2022.12.19.00.tar.gz"
  sha256 "575bd43307118ed692737a7710341bc97110a3e9f64097156085952363c5e39f"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17417ef34dc7a1e54d5ceacae1b7ef27b531482a993bb27117be073862c764a2"
    sha256 cellar: :any,                 arm64_monterey: "5656004074b320c9d3088bfbcae95ea2213838361c0e5968ba02abe6b6f3c70e"
    sha256 cellar: :any,                 arm64_big_sur:  "b1e407eec8666641c0d8b871647394b5db3f9ee19fa6fcc531b7f52cbe0a4da4"
    sha256 cellar: :any,                 ventura:        "ac1fe38dad65cfcaabde8524a801d19d17ed8df122c347a375a172c730c4d663"
    sha256 cellar: :any,                 monterey:       "c0328b3b8e6d7568fcdd7675582c27ff908da3f6717c9de6c017abb7903afda0"
    sha256 cellar: :any,                 big_sur:        "5af72c8157600a1d610b3ce81e6aed96521f7d0e9bc2f4e9ac6100909d51f75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b011defb0a50952c09e6509c174a27c3a16d21726a9ce05b9a33fc9b5eb78f19"
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

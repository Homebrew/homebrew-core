class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.06.27.00/fizz-v2022.06.27.00.tar.gz"
  sha256 "55dbbcf3ebe2d2ad4937e9cacca3a7fef2fee094f5eec5899131b85f3ef5fab5"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d556222a63ed6013c0380a276337b0a2bd31668e61aece72d851445e423048d4"
    sha256 cellar: :any,                 arm64_big_sur:  "410952b70741909f8c449bc3fb50c90d0dbf79b434ecf01f73fb918371db461b"
    sha256 cellar: :any,                 monterey:       "06931dfdf1fe2d512d7f7a9f05bfb6ea56ef0b75d770fa13ebf5abe484158c32"
    sha256 cellar: :any,                 big_sur:        "b9d15b872cf76714402caa998b95ade5e826b382b891994eb5a9df8afc46ce6a"
    sha256 cellar: :any,                 catalina:       "a019ac99ad2ad3b222fb4a75fe0397de71e343cb5b62ce789f9ea7cf52b766c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e45fd6900e9574e8e3a916cfd3df01c89567a2d3c5f9f62e771c318cf023e8f7"
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

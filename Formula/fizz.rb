class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.06.20.00/fizz-v2022.06.20.00.tar.gz"
  sha256 "d12ab05c457ef2607d601ed80f85ada5591b8133ba10791fcbef7ff0670bffb3"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f48f1fdc130f4dd4b5e0d4d215d51f14aad2c7bc23f0b7eddbdec85740da3d53"
    sha256 cellar: :any,                 arm64_big_sur:  "e522ea831edbdf39eec167b301cba27ba7620ebb2ef7a8943d63d6cccb797c6a"
    sha256 cellar: :any,                 monterey:       "00dc929f8ce31ad36d1b4b4a58e88c9c73707f19e008de36e3e06a431a48195d"
    sha256 cellar: :any,                 big_sur:        "98a56542662e2ec852185286259f2de98f73f7c4eb95f213cfa8234181f72acf"
    sha256 cellar: :any,                 catalina:       "e0cb08e71def66f6183d473d437a2633b5e22122bb79a4828984cf52a6d51220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "186c2c027cac14357e40f2fca04bf3f930da038502048bdf2522d4a891c26819"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.05.02.00/fizz-v2024.05.02.00.tar.gz"
  sha256 "3e7823ef99472cc232b2e0c99e8096756d3fe45cc5fcb9abda4aaf5b3b747cd3"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "52251e19ee0bfc1c999423dabcac19bf29ac982b8b3d8d4bab1b9bf0ad7e67be"
    sha256 cellar: :any,                 arm64_ventura:  "acbf3e19659614688658cd15c473ce90e307d83aa78e835a5cfbe0080d728feb"
    sha256 cellar: :any,                 arm64_monterey: "69a7c035a2955bfae046ea969b14f2ab68259e1266d96c75c32e7359f31a6c6d"
    sha256 cellar: :any,                 sonoma:         "e45bd18079c6951d23d8f29330ede636bf1572d478cb8a39bf92bb24c0b54667"
    sha256 cellar: :any,                 ventura:        "e2049a76b32f5be68e635136f68091b779422b6eca01a07cbe83b564ea697418"
    sha256 cellar: :any,                 monterey:       "6897e15f701f4f7c7b739b12ade0d78093e288c5cffaf928ad2994f9d9c0c504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5aba2aa669b63cf5fc67c725abed1a45236691534fcb75fe07294643d5cea1"
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

  # Fix build failure.
  # https://github.com/facebookincubator/fizz/pull/116
  patch do
    url "https://github.com/facebookincubator/fizz/commit/d1757073d2695415963195aeed02443e9b94649b.patch?full_index=1"
    sha256 "a18cf51af20b45e6a1149cd54f64f2cc3a7cb6ca703e5ed6a564c90c77ad9e96"
  end

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

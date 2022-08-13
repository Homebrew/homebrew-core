class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.08.08.00/fizz-v2022.08.08.00.tar.gz"
  sha256 "74cf7c76289f0eed76e6a000b6161d9e7ef27264f7d05d6bd3c2597313d68e03"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4322d2acf35eae38dc9ff2a2279378e5877a01671a2dff66822ad1de77432e1e"
    sha256 cellar: :any,                 arm64_big_sur:  "988f37021ae7243d2a76172d8566aa40cd159a4c97165a9ae10933a52c43ed0e"
    sha256 cellar: :any,                 monterey:       "8f5166d366f778ececda8c01e80edc99d1ce3127e99b0075de6d894e2d4c0236"
    sha256 cellar: :any,                 big_sur:        "3941ef63274d95b4e0c68f8d3d610cb3604158657026568abe5ff154ee409cc2"
    sha256 cellar: :any,                 catalina:       "1dde9935470faeb8628ff44fb076ca6439aa616064ea259ff509e438b12e8021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa3fc1cce04b668cffc625011265e6da58b7ba520434b6b1c7a2f90b80751c7"
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

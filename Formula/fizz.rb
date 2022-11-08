class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.11.07.00/fizz-v2022.11.07.00.tar.gz"
  sha256 "82b37d6aab136b9c8d755944526849aebf6e60a56de6c09b391d323b565e31df"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9cb8dbf5600d871aac02df001a677c2a68d49fe77f404aa613229c103cda54cb"
    sha256 cellar: :any,                 arm64_monterey: "3276564f824e8fb773e5211f3092e2fc94b6a8d3671d92ad7b4ac963155776b7"
    sha256 cellar: :any,                 arm64_big_sur:  "e995f6743507bd76e71dea88347839d246429bcab361c7055338f89cfcdf618f"
    sha256 cellar: :any,                 monterey:       "d20e04031b22b6b1bfe04385281dfbe3f32d731f96364c9424c74c294fa5313c"
    sha256 cellar: :any,                 big_sur:        "ed180b645ddc89aa1297cf7418e0ad37e1f00ee71bb5feeb8a4508dcccff3f91"
    sha256 cellar: :any,                 catalina:       "104fe0f3aad636a2f8042c931609bab88ddf747aac177df9ffb7e3538bff5cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b817555e08e5ac4a0d16b820add3eb67fb1eb04a9ec1b5e62b38db6c862d804e"
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

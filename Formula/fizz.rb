class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.12.12.00/fizz-v2022.12.12.00.tar.gz"
  sha256 "80e5002072d01bd94eecf68d13e2ad9dc008773d9abc0f328f08fc9a4a0067db"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4aee5dabec3f1f5b8c00f4c7812ce5f3ab95c95d8b0157fa3c0da8a71ed623e7"
    sha256 cellar: :any,                 arm64_monterey: "2191644648dcb338056d5c33f079b2e09dcf0e15f761ad824b740b844affb83b"
    sha256 cellar: :any,                 arm64_big_sur:  "a1a1e897e8849d7b757539a8f7bbcf5fdcbe7e9d00a2a4bb2b91e15f693adaab"
    sha256 cellar: :any,                 ventura:        "6156a76879c19920b71e25284401f7d1e2fa3b5074b70076edc8933af2e71387"
    sha256 cellar: :any,                 monterey:       "199f54ae20dec2c84205846928c58652350dc1b60880e184625ac617db9109bd"
    sha256 cellar: :any,                 big_sur:        "cb6cc6d7f740e10c5da59564f83dc2d6d88fe4106933273d0ce08e554850bc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a9d09174b8ce02741e9710a605ca4f69a61c46fc3a55d6f60a38ae60ae0515"
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

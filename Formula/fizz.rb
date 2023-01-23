class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.01.23.00/fizz-v2023.01.23.00.tar.gz"
  sha256 "2a5bb6f14d2c429f21d62f5a1f2cb70f8783c9290c5659aa8d4cd322f632fe74"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a9097ebd0dab10cc0b80fcbbb939d99815a126107bae009e9a9984f6adb9d216"
    sha256 cellar: :any,                 arm64_monterey: "65f9ea9f8b3fde25c2eafb3ef28035762279394650aa6591432f1c7b64de52f2"
    sha256 cellar: :any,                 arm64_big_sur:  "b5d4006ddf278f5fa98975e1c18380a42f742491e55545192dfe759c7323a9df"
    sha256 cellar: :any,                 ventura:        "ddcbbf9e0b22ff31bad0796d7caeca034b180cb90c72174076a48cfccac468b8"
    sha256 cellar: :any,                 monterey:       "ea28324449247551e432f2f673ee269826f0709c3e0103eb3ce8001cee503b29"
    sha256 cellar: :any,                 big_sur:        "6fb8b162f2cec3fe47d85d0715d85c353c28949d79050b75536b89c3d5233a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cfd1e43375aa0d760e0865359bf02fcec5218d36cf6e2e2f7b33d725a61dec6"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.10.24.00/fizz-v2022.10.24.00.tar.gz"
  sha256 "c5d00228087b266031732a8a9e09e1d640f732874a7b952e3589e23dd35ed547"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "16a5e883b805f7722f9126de9c0a2353729ec32b618c33813212117aa30d674e"
    sha256 cellar: :any,                 arm64_big_sur:  "37fcf1d9117ffac78a57147ba4979cb7daf800289b7d83bc5fc9d5178558c155"
    sha256 cellar: :any,                 monterey:       "5eac914bc7adbcae326f7413126fbc05ce50ff16fcfb0e2072813b5b0bd3c632"
    sha256 cellar: :any,                 big_sur:        "7626a9237f5c8525f367e95d22b4ddd21f60112b3d2076e0a7b25b75e946f1cb"
    sha256 cellar: :any,                 catalina:       "ab8d53eb92af4246b9d063351a62f8e6c8bf9cbe90d5b5689665122cff5761d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e9f71075f4ba22ca3a0541eea2eaef0f8002caa260f24988c9a9af5402dfb70"
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

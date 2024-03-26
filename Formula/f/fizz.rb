class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.03.25.00/fizz-v2024.03.25.00.tar.gz"
  sha256 "fcd879c0471de3de24e6e01b4029055de9b4d93aea5994afa31cfd3900759bd6"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bd4d13fbbc4336f5684930cac362ed18f6cc7258b62266a28d9577303e2ae38"
    sha256 cellar: :any,                 arm64_ventura:  "a05d117de5a401ec214454854922e6942486ce3daee2d682b42e7b3556ccf10a"
    sha256 cellar: :any,                 arm64_monterey: "531013d3616797b871716f5f1a290b55a0bcf1e4bc3a4335901462155c74ed06"
    sha256 cellar: :any,                 sonoma:         "1da2ccb1bf2e142890f69a3309d0cfaceb10d1dc52f5d83900c0500bb839c30d"
    sha256 cellar: :any,                 ventura:        "5d60b6c81f0a86401cf89b4d9ae70b8f46da594c267800d5445d4fa2aa2031b4"
    sha256 cellar: :any,                 monterey:       "206742f0d628e710b6174d3b0cb389e4bd7162f2ed21be435eff8d8b39148c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da5f99ed59c303bf5b818087ba35ab0567b5f98c1761b24a5ccfce822104a21e"
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

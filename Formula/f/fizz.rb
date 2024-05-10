class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.05.06.00/fizz-v2024.05.06.00.tar.gz"
  sha256 "8392773f029f7a0a596942ad668d2f07a15e09ecd1c565ee61e58f0e65d67673"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6db6f998e2f1a5bdd7c58f8fbcd2b5ebf6e1e2d133409fd30818eb976f7db81"
    sha256 cellar: :any,                 arm64_ventura:  "5d27378c03b9c66f84208a2ca4724b5c37325b4255aafb0de87a3722b5615c42"
    sha256 cellar: :any,                 arm64_monterey: "3883c03d7b4fc06e9eb0532c84f14a527da3541bb1d785494de154f4fc1883e5"
    sha256 cellar: :any,                 sonoma:         "c76fb6ed58cb43b798c3cec20ecd1ccafbfffeefb417b8ec5e55165d13487149"
    sha256 cellar: :any,                 ventura:        "1d2d5db1c6a6be39ab63104d5e7f01a757980e1bb72d562fe8b84fb79e26586e"
    sha256 cellar: :any,                 monterey:       "3b746d9feb20983a36a97535aa14c37b917e5f46f1a9f7bf01595f91b7aadf03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d19fe7b97bd0b3863c1ef6d181bc58750c839004e921bca08054b16f03c41eb3"
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

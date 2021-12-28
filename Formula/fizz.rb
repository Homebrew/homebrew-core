class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.12.27.00/fizz-v2021.12.27.00.tar.gz"
  sha256 "4ebfcbc84e1929ce56f941c0799740865ac4b1a115c6275c220b6d7fb2b609e9"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8d0fa798a59a2d7a5ab9b99a15c776a4fe2439f969ac6aca7d5af0353e6aba8c"
    sha256 cellar: :any,                 arm64_big_sur:  "521940e5b8dabf367bef4d4f7cf681f5f8f5f835a534a576e95eb247381694c4"
    sha256 cellar: :any,                 monterey:       "f103c0df47d0ff97b9bb665d27bf88d59031a29ee25b744332364005d3044085"
    sha256 cellar: :any,                 big_sur:        "178ff764908c34fba0d41588d8af9cfcb3d3da77742122573ce6eed1978b21c4"
    sha256 cellar: :any,                 catalina:       "656d5e6ba4bd69a17510c37278435ae7315ef75e68d2058430dbd35c4eb4fab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d395e347e8ebf1437a1dbf53cf88209dec35570d99c74a935125418df7e4de"
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

    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
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

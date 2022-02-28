class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.02.28.00/fizz-v2022.02.28.00.tar.gz"
  sha256 "56ecd1c8cd543694f944bbbc558f990d8c8c96a1e33ae2bbad60a89b83f2ffcb"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a99d382b053e8c7c8d9b490e41c835f8e8e2181489fcf9610e383b5458de2468"
    sha256 cellar: :any,                 arm64_big_sur:  "5913a040640d308c26a5a45d6d622e008d42477335aa4074b0a9dbfc8a1ea5e3"
    sha256 cellar: :any,                 monterey:       "cd04da7b11ecacd5791baa576e7662ab9e3d6ac9ca76144c9f9610e9b36c453e"
    sha256 cellar: :any,                 big_sur:        "30eac81bc2bba9dbad56d0da8b8c5c55d2fd0552330728f5e9246e29f43d95b2"
    sha256 cellar: :any,                 catalina:       "dd65bffa585736c6d45abb122727fc5d3e2fcc7cf2aea16413a477218c748df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f49aa00c767a9261141e993f3bb7faeffce7f688e7b744b9c2b23b1718d478"
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

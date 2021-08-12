class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.08.02.00/fizz-v2021.08.02.00.tar.gz"
  sha256 "429be5bfdca71cdb41b92523508abbc2f8d6b39ad5ebf3585f51f4231ca1544f"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "31be96d50fd1d1865cbc2225f68acb2402730bb9d34e067561f790e405d23f2c"
    sha256 cellar: :any,                 big_sur:       "e105a1c5e7e86c508dfb27c0a469de8d941ec80cfc43f9c375f58f34030b82c4"
    sha256 cellar: :any,                 catalina:      "64025751d49b3592335afb5c2d95d0275aab8011036efe23dd7212065973c8e0"
    sha256 cellar: :any,                 mojave:        "3474a9a02789f0a4bae032b25fb7af31cfdbb8d4b65c95244701a9b975a739c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b13420eed88e4f20f8454bf594c0a6a0b5d494d4bec1784fd6934152d3be07"
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
    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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

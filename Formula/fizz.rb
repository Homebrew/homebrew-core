class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.11.08.00/fizz-v2021.11.08.00.tar.gz"
  sha256 "96d1e37086e9ce5dc997d39d5aa5590e0ff587c1cd9641337fb655b9a934c2cc"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4af79e7be734d73daf588b6853db3350ec367ccb8efd8e26a4e768375020962f"
    sha256 cellar: :any,                 arm64_big_sur:  "666a3751f3f77f9b77456b391bdc5558222de65f593c66bac3ae41f45d5aa8d5"
    sha256 cellar: :any,                 monterey:       "949b97cd4e8646c63629320dc6c6bc6ca8e25e2698122994927111439d546a03"
    sha256 cellar: :any,                 big_sur:        "1928d5e56014ceb6fb220a1b2230237613f859328babee9ac93bbdbbe66f3374"
    sha256 cellar: :any,                 catalina:       "af3cbb5a19308ac8bc23a3aa238b9382cd8b9612394667a5b193ee4b8c1780c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8af6a3bd482f6022643fba67d443122d5ae16aee47fab50ad19da7cac421ab"
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

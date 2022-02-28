class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.02.28.00/fizz-v2022.02.28.00.tar.gz"
  sha256 "56ecd1c8cd543694f944bbbc558f990d8c8c96a1e33ae2bbad60a89b83f2ffcb"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20263172b5c8ff5a3b906b3e0126f776bbdbbd1e30c65237f1ca36019ca1a641"
    sha256 cellar: :any,                 arm64_big_sur:  "003e298ffedcd75ce481443b75b31ed5ea99728579d2eeee28cd1e38f29a3981"
    sha256 cellar: :any,                 monterey:       "d142294cdfedeb04b4cc2912d6d3015d2c1e3449e72d8540c1916e692d78c45c"
    sha256 cellar: :any,                 big_sur:        "942ba1dba7c1d6ee58b73a2002fc8e9a9c1b24b5fb35ca5a58631a3a6f72bdac"
    sha256 cellar: :any,                 catalina:       "17c51fddd6781613ff0a3312e904cf75d2d082cf3dbfdbd789a197631c963399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e466c5f473914e2cc87a6c94044d82d5aff1dfee65368fc91f83881bacf7fd"
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

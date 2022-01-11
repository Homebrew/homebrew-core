class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.01.10.00/fizz-v2022.01.10.00.tar.gz"
  sha256 "fe6dd9dac1c5d69e817972def03af2f6ab22808b4dea20a0ab92ac8c86518cf8"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6059f92b630ca108ffcccec0ec0577b3c8b60e7028fb8fa2f1265375efe76453"
    sha256 cellar: :any,                 arm64_big_sur:  "74831e97eca51af8950d501235d0e8c405bc2a22681ce66f78925d43e28aaa86"
    sha256 cellar: :any,                 monterey:       "455016562b6cb5fe3464b09c4297d2246e9538aeb9c07c67c952c84b5bf17921"
    sha256 cellar: :any,                 big_sur:        "cb49b95da5d3935e3725c7f22ef20a34655976c7048da8bf5a3f675abcd8f73e"
    sha256 cellar: :any,                 catalina:       "61867d531ca1e2ce2f3663111804baf66c155825eae1e6c7513c74d86cb0a34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7606f228329a01af90677f0432fb5a60bbdf7bd6cb44056d04718bb953128218"
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

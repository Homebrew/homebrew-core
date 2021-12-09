class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.12.06.00/fizz-v2021.12.06.00.tar.gz"
  sha256 "bfbd3bd6b2969b474597c6ebf75ed9ea31833908d918945bebd9f4f08d8d1515"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff20d729d4635a429257229c2e90b1c4679618ce997007d21df16a8e8951cdd3"
    sha256 cellar: :any,                 arm64_big_sur:  "830b3b4ca61b12768cd4717889b81aad5d0e31b7f9e10a657293a626bd66587b"
    sha256 cellar: :any,                 monterey:       "caf6e818a08df4549ce0ca62b2b76c177ceb231a19239417e4a3437b1ed069b1"
    sha256 cellar: :any,                 big_sur:        "ffee9c2848b0f886200a817815efeeead3ba4db024b16c068abc178783c602e1"
    sha256 cellar: :any,                 catalina:       "d92231697b3d2b78cdc6aa1f9ef45710503d3fe45811d76f518b0b0c1dff005e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6595b91341fca8dbf4b854447984a8781f9bdcb318ebea490930bfb4c656a280"
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

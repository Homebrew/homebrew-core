class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.08.02.00/fizz-v2021.08.02.00.tar.gz"
  sha256 "429be5bfdca71cdb41b92523508abbc2f8d6b39ad5ebf3585f51f4231ca1544f"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8fbc9e78130b1dc0b87c49db9385db22849aa157b29ffe309c5893c3bb13382c"
    sha256 cellar: :any,                 big_sur:       "b8903994018f142c8bbae4643d785822e6a6b620a1545977afc1c982ff17b855"
    sha256 cellar: :any,                 catalina:      "be7a29105c7b702ca0f3baf50425d8c829c3202ad4b525ae2263255d2870bddb"
    sha256 cellar: :any,                 mojave:        "bcdc0f1d3c7111d14900ac8001e30f81b956b5dbafcbb3735d65e39b6f59f489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e45e8f746cecd981aedec558d1c9c3c6380310de325124ed0ebbb2bf1b11502"
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

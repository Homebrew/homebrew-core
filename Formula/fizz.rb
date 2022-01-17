class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.01.17.00/fizz-v2022.01.17.00.tar.gz"
  sha256 "b5eb358d49ae38ba841a662e9f93c91cadbdd20d2776a1c28abc8e8e95fc3c80"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ba55fd8fa690236ae43b8b9923a2ebbefa38e2861ab527f2e8e6a763af2dc2c"
    sha256 cellar: :any,                 arm64_big_sur:  "c19b907c40874a9575166cd78ad1419ab00b539785dbd159d661ea2bc8c1dcec"
    sha256 cellar: :any,                 monterey:       "5bdd5e39b834666035eef5c565fb17c7c06731744c4a85f6310536432b1e4bf3"
    sha256 cellar: :any,                 big_sur:        "d28d0cfce42bd150d2fb034503c07ec61f864873e42ea05851dbd28eb46909e6"
    sha256 cellar: :any,                 catalina:       "899dfcd278354f04ca79f13e4dcaaa8cd092a94a2dcef289668f40a1893798b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e363244ae965db4ae8a84f8b528537cdf3d8ed013fd3cb1a2d29061b3dabf39"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.02.14.00/fizz-v2022.02.14.00.tar.gz"
  sha256 "7b5d4a00d551b5b0b610ac8a69e69283e4d700838cf0ab64f606b35478a08d42"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21c574a2ed6b5b5e31e5d8cd45dd8ea792cb05d489d0bbd12caf8ee71550fb0d"
    sha256 cellar: :any,                 arm64_big_sur:  "9afb5f4c6e1c1566c5e8061e8f354405944c15358425bde188af8932885133e8"
    sha256 cellar: :any,                 monterey:       "1a0e0859750231bff830c9170d5082212635855c5c0384f071cc72d6ade9fe9c"
    sha256 cellar: :any,                 big_sur:        "385afd42c7f6eab96e18f9235fc3dc37b8baadf103d3188dabb2251eab9b5b8f"
    sha256 cellar: :any,                 catalina:       "bff278749b5932cb4f2a5e6980a2f03d89d1473431f9d97443ac04a0f2b7bc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41f2cf654b45f1b6a1ddcdec15213c60ea5f25e54769937f9b7363a7a186d11d"
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

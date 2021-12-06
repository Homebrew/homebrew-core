class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.12.06.00/fizz-v2021.12.06.00.tar.gz"
  sha256 "bfbd3bd6b2969b474597c6ebf75ed9ea31833908d918945bebd9f4f08d8d1515"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89b297f0386f9a2fbceebb46d503ee4df084a2ac08c493354486aba4721c9e4c"
    sha256 cellar: :any,                 arm64_big_sur:  "31a5a3e5b6651bda5cc0b2147933ad45dae6f28bba5d5d90a314fe7360bc5e2e"
    sha256 cellar: :any,                 monterey:       "4b49b2c3478cfae789403fdbe967f6eb1db7caf00cb5c92b940b7105b75aed1e"
    sha256 cellar: :any,                 big_sur:        "91faf04471a52abee5952ca16074aae6710b255c5e61a4941009a56ae48d2bed"
    sha256 cellar: :any,                 catalina:       "6e0cbb5f1ad197977fd2ffddcb1a44efab3056fb159c47a1a28bfee134905e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4954819248ad750c02025858a1869578adefacb8cd376c3f4196937dbbd082"
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

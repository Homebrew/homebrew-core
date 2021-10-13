class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.10.11.00/fizz-v2021.10.11.00.tar.gz"
  sha256 "0c3b49458408f52263c30ab32796665e5a4950eaa017e9f8fd26f51c5bea189f"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d607def8116de0d330e5256a561093cebb1576d500187f2d1868317a742229cf"
    sha256 cellar: :any,                 big_sur:       "a90a7576d55320e42e89df54d70d034ee19ec98ce0575e5417b308541a56d19f"
    sha256 cellar: :any,                 catalina:      "3ec41b4e214e113606cd874e23f606c5413104555983d72cdee651b025afe0e8"
    sha256 cellar: :any,                 mojave:        "46256e39c743c7383067f948995182dde198f97d9e1569e1a71cea288cbe2d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852a86d20b7f8568b92458bd0f62e1dc870e0d5a2f0638fad9f0d36b0c28081f"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.01.03.00/fizz-v2022.01.03.00.tar.gz"
  sha256 "fa140140108dc3226470c59508de15e7761787b2e158171f588eec4fc415f4f6"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bbc877155e3a2b90fd30c40d2e93a467bbf568d256ac01e698e32a1991908890"
    sha256 cellar: :any,                 arm64_big_sur:  "68cfe4a2e3fcd6e978719035ae4c8cb8c7c818759153dc294de3d6cd05c1d15a"
    sha256 cellar: :any,                 monterey:       "a076f253f1dffbc7692c37b62c45dd1fbe46fa02a836076397c248b16cecba3b"
    sha256 cellar: :any,                 big_sur:        "b3f0418783b0ef5dce9db71626eab7de7cdc54bd13c1ed9a36577431d46b4ae9"
    sha256 cellar: :any,                 catalina:       "9b3443125820750b26a269a4f0a3d695c31ab1f191cbf225142c0663e2da5990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c87cc5f4eec4225c6736ada5484507b79b88e523883c9a7b2308d7a3bb4c77"
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

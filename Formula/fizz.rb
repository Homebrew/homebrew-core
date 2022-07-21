class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.08.08.00/fizz-v2022.08.08.00.tar.gz"
  sha256 "74cf7c76289f0eed76e6a000b6161d9e7ef27264f7d05d6bd3c2597313d68e03"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0a16d13c03f99fd35c47f3528afda470d6653c1a7041344356ebb6fe002fa7bc"
    sha256 cellar: :any,                 arm64_big_sur:  "c3bf550d89cbd822b1a7b1e2744d39f1e390a3efb0c4d24b289faf7a2d52b64c"
    sha256 cellar: :any,                 monterey:       "f18901511e59bad74887af75336226bc375aeb481f0f24934c5ce6d7eed6ef4d"
    sha256 cellar: :any,                 big_sur:        "4e44b686bc4ca8a8d5e899702499cb4877ce9b5cab1134533d9e9273f7975140"
    sha256 cellar: :any,                 catalina:       "2d2a3bba223159fa034c5ea1723fcbb1a52ef14218c307ef1e9e67145a4a2b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b3695a225c09c9803ac0a4a079b37a82df1c2a26c79ae55564d6d6e6cf430d5"
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

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

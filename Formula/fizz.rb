class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.05.16.00/fizz-v2022.05.16.00.tar.gz"
  sha256 "086c583b3124972abc2380a76af19a0b58be034e636c2046cd83686ebf35cdb4"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c75ef991f076121450c5abc6b7809778d3879642af181b32a1121180102a4d8b"
    sha256 cellar: :any,                 arm64_big_sur:  "b1617c0b03ee4a013513ddf2c5091a61bc2188121a2d04ad9a9355dd5225fda8"
    sha256 cellar: :any,                 monterey:       "3fbfc0062554ee2a2cad5c3e81de7b9d150814358386e3ad5b7715f84af59c82"
    sha256 cellar: :any,                 big_sur:        "b9aab071aed12635a991f99a5fdf291b7110497e5cbc7c02dbed4fac8a5fa0ea"
    sha256 cellar: :any,                 catalina:       "3886354862a6a0e6f0a37a7eafafa83a98b180c76e768482661a3e74006a3c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b2648ace1bd5910db6c5e94101afb6725e407d8216de7c45017e8a0993bb33"
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

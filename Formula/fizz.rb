class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.12.26.00/fizz-v2022.12.26.00.tar.gz"
  sha256 "98f02a23d42d5a9d053c95f4102863dcb7058de7627eea6052e6d5f31cc538ee"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c81fbdf6029063a638aaf02d5349436fdc5b99ca0d5bb2e81dd07f7b6df2dc4"
    sha256 cellar: :any,                 arm64_monterey: "8181aa46ce708dd84d63814a9e7ad23f7526c39a317a4990f0be76f964c92895"
    sha256 cellar: :any,                 arm64_big_sur:  "5de1f670d1ccdcef445436a951c6efb1a879f2050748cced3fcb26dd155e9120"
    sha256 cellar: :any,                 ventura:        "3bc75f347ca3deb3809bcd7f7fc10fe90f3b32157138dffc200874d1a9772e94"
    sha256 cellar: :any,                 monterey:       "da1140795f9b6a6e6d627275aa9e1dcfc8f4fd64bd32b07f062c426df71de046"
    sha256 cellar: :any,                 big_sur:        "ef19803d81a3b46c1315e0a4ac60dd75b2889227eccb34ea621cf816d15275f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d901fd59728d8f149a9ef76a93f471a03511f6ef045de5602d6bb34334978d"
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

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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

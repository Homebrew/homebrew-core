class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.08.22.00/fizz-v2022.08.22.00.tar.gz"
  sha256 "4f32c2a54ce856f87a57d144a9b70d46f621f8904ae3b90b56184bb16c975150"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "adec751e289a82d40142fb764265d69c3f721eaf712382222d221178d45702de"
    sha256 cellar: :any,                 arm64_big_sur:  "0dc3392354ff5429f86aed93553a79f54a5fde09589ea36b257ce17ef61957f0"
    sha256 cellar: :any,                 monterey:       "efd200b522ca06b0006fdbb16190ce77711a36f89f0cb4acb879878405882268"
    sha256 cellar: :any,                 big_sur:        "d89661faeef96b3c5d85a1297ce888ddad82dea0f77db62bb6919ea675cd78fa"
    sha256 cellar: :any,                 catalina:       "04d255eae7c51abd0f00948203a30c49c95e9cf0034b2e016f401b3c0d4db2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d6daa65ea5e1ed0ff2c94cbcc1f6e65d68a7e471d09ee31c6f36f22a1ebb36"
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

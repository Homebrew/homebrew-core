class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.01.30.00/fizz-v2023.01.30.00.tar.gz"
  sha256 "53f3b99bbd4e01fbebbdeaaf044ff32b55021b1808c4d458161bacef0de3db9e"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0dc0247d294aab622263504a6de2e0e075d25172b31f9563c73df630c442382d"
    sha256 cellar: :any,                 arm64_monterey: "8b535e58568e42e05e5f518b938f852514efd7fb87a16844da7d8ed7eb7502da"
    sha256 cellar: :any,                 arm64_big_sur:  "28cda3dfe7e17f3b8228bee03dd283149fd91d579c9b6f01c5d312dec3d2530c"
    sha256 cellar: :any,                 ventura:        "be6012dfc29c17cca759ac6de948a335cd9d709b4e00429e58b797597aae3246"
    sha256 cellar: :any,                 monterey:       "d2234891ade5ee4b2ba66f3c9e8e08825481dc9d8882f8c02b9a5ef8648ef8de"
    sha256 cellar: :any,                 big_sur:        "3a4b80d9e82ca46d779564e9f000c53e3657f42dfc1c1f93df61f1f4bb74eb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65a942f2e3a3d7d33791d685efe8eccb33887615e9a50d2dcf3aeab8b42086e"
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

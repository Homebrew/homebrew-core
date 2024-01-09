class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.01.08.00/fizz-v2024.01.08.00.tar.gz"
  sha256 "ec2dc1b2238e654e8b40b63157cfe343f44e05a59da53e095aadd5e4ec627144"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ce82a3f5a2e8b94c5fd9a699d0a4ed5009840366896a5ab11203d10273545cb"
    sha256 cellar: :any,                 arm64_ventura:  "ecf364ed13de5f65f0709fc8e6ca33a5201f855f08cfa914a0785a1d1009c1e0"
    sha256 cellar: :any,                 arm64_monterey: "8dc4c75c4e00628ba1f9693c0e0dc671fb3d60eca680ece0ccb2285878551753"
    sha256 cellar: :any,                 sonoma:         "f4f021bb19ac3c226b950b5cf28a453d928aec23fa4d996ae03a5892f0648620"
    sha256 cellar: :any,                 ventura:        "62dc0203fd2e16db6273d38ed4a878fd0ebe60d2d82cc7061ee0631361fd6d25"
    sha256 cellar: :any,                 monterey:       "5df144750358c9be44ac669cc1b38e673a13cd21663216e054ac0aa7aef7a475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41281803071efc8e5c879235b1dace87170005ff038399a03bbe711821f3f03d"
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
  depends_on "openssl@3"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end

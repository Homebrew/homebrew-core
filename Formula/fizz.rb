class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.01.30.00/fizz-v2023.01.30.00.tar.gz"
  sha256 "53f3b99bbd4e01fbebbdeaaf044ff32b55021b1808c4d458161bacef0de3db9e"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "591ad5cb635ba66af0532cf2b0fa2c49b2bcbde8666a89c6e5f1c0531d354e0c"
    sha256 cellar: :any,                 arm64_monterey: "f914c986fc9041a4b22585545d627178e91f8973258d9ce768ee63fc2acfb097"
    sha256 cellar: :any,                 arm64_big_sur:  "ca5cfbebc125a3785e68d735a3ebd1b1cfbb43e8c6f6a27f06ed547e002e0a6c"
    sha256 cellar: :any,                 ventura:        "5f3495636e2e2d99d96b86e5017167d003cf56dc9a3242c1c2e50f19a24cffd8"
    sha256 cellar: :any,                 monterey:       "4137ab40a64144d09da4c85088046c1c0c34cc909618fc7fc8eef2054d578a4e"
    sha256 cellar: :any,                 big_sur:        "eaab4d95233f4cb67978324a9f8b24b5becdabe62f4ef640467badb70c5b6567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038ef22c1995181a83c61e4ee3779d12cc04a3660ccdb6fb8577bc6e964d9cf8"
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

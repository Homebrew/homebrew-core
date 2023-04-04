class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.04.03.00/fizz-v2023.04.03.00.tar.gz"
  sha256 "ab0279796faaa2fae443efb2e8258d7a78944528240102f032ff471b3054e797"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef871154975b163b0871d47d25b41fb5b1638f3949c045e0237d09d83e5b7a22"
    sha256 cellar: :any,                 arm64_monterey: "65680ce69a2a455bd7efa434c3e0475c9fcba2f2630100f2a8653663a89e299c"
    sha256 cellar: :any,                 arm64_big_sur:  "9ed16fbd02c9640c9dcae3e3ab54e916e0195c0923e7c145c7672c7b8876211d"
    sha256 cellar: :any,                 ventura:        "005e43193c9fab73362b5a7bf62486e9d8e9fd22b5dfe8d502a62fbc24d3d470"
    sha256 cellar: :any,                 monterey:       "653bfd7e018566704c2e6402683c0079080f0e2a8db11f748929ce8c3c799a30"
    sha256 cellar: :any,                 big_sur:        "4a64dbd988e570362fbe404f7daefc260678e5a1c2492694e85a447a29eebb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815aee4e2803cd7cfb9015df24af60e21375c6c46cac840f5095b85bf80e821b"
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

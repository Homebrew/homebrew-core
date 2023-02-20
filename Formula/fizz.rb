class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.02.20.00/fizz-v2023.02.20.00.tar.gz"
  sha256 "063ef5ac27da0a455ba0e8fb669263b05ef595872f0c1f6ad06f4f76d16e66ba"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "486f40f108a97da5f50af4eaae09d2d2546fe59b999a1be89d83e65fe7a2fb7f"
    sha256 cellar: :any,                 arm64_monterey: "a6faf7583da951794aaf22ec7070fb63c3f16e80553a533c5b0fc7c85f3f374e"
    sha256 cellar: :any,                 arm64_big_sur:  "92fc0baca55855646157c903510d5693ea954a85974c51c4fab38772d7ea425e"
    sha256 cellar: :any,                 ventura:        "d61bee021ffcd81a51563f21d0b43d9a20121cb31b8bff5604b9c478b070dec4"
    sha256 cellar: :any,                 monterey:       "61d816ebfdc7885f81b6cca816e19600f65e4ba1a721fbd6891e6dd9da88858a"
    sha256 cellar: :any,                 big_sur:        "683b850640765fc111721ce73eaf4f926636aeae81a34a30533b64d997118ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bbe7a9ab79df510510394fe0738928ad6e883ffac2f913f50bd26e451f4b1a"
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

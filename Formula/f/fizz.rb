class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.10.09.00/fizz-v2023.10.09.00.tar.gz"
  sha256 "e5f9ace33e098eee6af9fe307d66853dd1afc9c1e3cef681ba3858c7b65b3ed6"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab63c1603a802b069c4ff7d8488e753f4ca4c0815aa3b323032fb1e40d8180d9"
    sha256 cellar: :any,                 arm64_ventura:  "5760d13e9b91a09b0d403458ebb8cac2373c4f6f4788d147abf4f7ed11f46f57"
    sha256 cellar: :any,                 arm64_monterey: "f2c70a6c6e4fdec12289763b28e24cbc35305379ec7dd9c8620cff31a9190e1b"
    sha256 cellar: :any,                 sonoma:         "80223d7969e6db447b87da75f973cef3bc83171ec062bbc1477c1d7ec4980456"
    sha256 cellar: :any,                 ventura:        "ca064efcdda3f25a6c0e657252c164307b96f4464c4857eedab7439d0045d14f"
    sha256 cellar: :any,                 monterey:       "2fec8202f9902792451d8b7d56af84b18c0a35f2793d4a5ab922178cd8b9c163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a172d3b3f05095edac9a6332f288fa2802bdb5f7195875c6c55c8934c48a96ca"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.10.17.00/fizz-v2022.10.17.00.tar.gz"
  sha256 "6c7069cb6812e9ed990b65e60c4d87b59d59c4a11f26d0ae1e35498e47489d9d"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35435e3cf1cfb446d60147d3eec45285afa4015629324da7faa02a37890ff79f"
    sha256 cellar: :any,                 arm64_big_sur:  "9ade3b9858fae60041942ad8cca02e6e60661f569efe8ccf935b2cc538b2aee8"
    sha256 cellar: :any,                 monterey:       "5315bc12c9f55b9e870ec63d1ad22e3542b9baee0450ad1fd582cebb10f7bda0"
    sha256 cellar: :any,                 big_sur:        "103e48abe537dea097206e0bd26fc2800652e8ac7f84417456b06a407cc79c2b"
    sha256 cellar: :any,                 catalina:       "51cc8a697cae45d1ff9f479411e50d04be10a2344d7f70e8108146faf8f39091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38590de72cbca285a3f9b6fa10f5ed14d21c8ebbd9544bc5da997ebfe14ff912"
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

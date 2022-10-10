class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.10.10.00/fizz-v2022.10.10.00.tar.gz"
  sha256 "3fac3c6fb417543b171cc2a7f94c290fa175b92248176655077e83f9d7144c7d"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "982334b257036558e5f433a2a0f1d191821e1dda520e6993085076f3f6cebe5a"
    sha256 cellar: :any,                 arm64_big_sur:  "131c00ec20cb8108c4aeca954862f4736640f50ea299bc232202571975665271"
    sha256 cellar: :any,                 monterey:       "8c0a984b2701acfe0d03f5b8c6e407367fef65f9a55540681ea36524503bb986"
    sha256 cellar: :any,                 big_sur:        "e9fb5c233eeb1aacb2342f691c6f52d2b4c75095726de49ce2d6e50a5b931265"
    sha256 cellar: :any,                 catalina:       "694f6935f3d71ba5ca6ff82d3d803cf4d43ec3206f8e7e490e8eff9a94d2a5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f0cf1a42599252d62104d1659e2bf619b3612300b6a20c39f6487fb33c3047"
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

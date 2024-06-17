class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.06.10.00/fizz-v2024.06.10.00.tar.gz"
  sha256 "84d6dfa32370412d2a7c6fa5a66ad26d124a633e9c1f2cdfbd85e881bae72302"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0157717483095fd4b725abbc3d1f991ebbea6d98f5639a32d3964312b833e74"
    sha256 cellar: :any,                 arm64_ventura:  "ff2b998a228e6d6132b6be96096c908b41354289dcac18c36d412fdfc1ebb37b"
    sha256 cellar: :any,                 arm64_monterey: "7188c8349ebd04cb1dd859613997320d5032699609d25cdd1b9384f579c4a7f3"
    sha256 cellar: :any,                 sonoma:         "1b74c7b440f4ff5fb215dc96e6d670092b85ef7c59cde5783f9dd67a536dd95b"
    sha256 cellar: :any,                 ventura:        "01d951d2f82c26a790fcaa31a2f58088faf21ef5fb373b0199b676d3f0a297c2"
    sha256 cellar: :any,                 monterey:       "ef4c91285c0c69491595bdbc698687646f8dffe84b5b914a5587b7dedcf1dfaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9d2200ebfb752367aa58467f4a1e385e74c3256ca7059647955f76e7e44c99"
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end
    system "cmake", "-S", "fizz", "-B", "build", *args, *std_cmake_args
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

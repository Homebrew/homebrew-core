class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  # Remove stable block when the patch is no longer needed.
  stable do
    url "https://github.com/facebookincubator/fizz/releases/download/v2023.06.12.00/fizz-v2023.06.12.00.tar.gz"
    sha256 "609f053d3b0cd1d1f1ff83852af29e812de66aff2b488e5697f744e4c6f7040d"

    # Fix build failure. Remove in next release.
    patch do
      url "https://github.com/facebookincubator/fizz/commit/0dc415e2e7dade586b445946a939d4f8ff15e8d2.patch?full_index=1"
      sha256 "8d75a960bd1087ed776842fb539f87ec38ed2bad9d18aaea01231172c2386c45"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2014c9349557f0b3acec6022e1b1afbca56f27208c68d7ce66f58506b54a62d2"
    sha256 cellar: :any,                 arm64_monterey: "6aa34176d4c99440fa9e9f482c2dfd847b24967937721e10704367e643fc7fe7"
    sha256 cellar: :any,                 arm64_big_sur:  "d55a4fafea490127b948b1965e49526945b25cfbcd8bd0a533e9cb557718e93c"
    sha256 cellar: :any,                 ventura:        "aa1fe992ac94117009f4638a4667dbc011d5b4d66133ec2d2a40ade95f6d3364"
    sha256 cellar: :any,                 monterey:       "e04055a7e720d0f15d62ab42156129b7041d4b085ecb2a5e17f98999b2da9106"
    sha256 cellar: :any,                 big_sur:        "62065700db55af3156a492c0f34903fd404dabb12ae3cee3d22cfe10b4f397f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789c1d80b631dd05e1eb79ffd0f6865b880f9bf8f91f58838fdd3eda6eaa7be2"
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

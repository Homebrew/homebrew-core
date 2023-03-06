class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.03.06.00/fizz-v2023.03.06.00.tar.gz"
  sha256 "54d91581da093d70cc0baf2a391c0bd64b6015dc70c90c1111c2a4d40240f5f7"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "abecea584df82adab847b456c868315642369f94b16d84fb8cd55f2f07263919"
    sha256 cellar: :any,                 arm64_monterey: "765efe1f6b845c7637f6e2897d7c5f361b55671b7bad109ea3b647a2f5486a7f"
    sha256 cellar: :any,                 arm64_big_sur:  "5515e80a0a4f70b46c7640064e67b8704f3f24fb23534393919aaa0a1dc23e1a"
    sha256 cellar: :any,                 ventura:        "90c97f749b8e56963bfdebaf5184a0cea02c57a7636f4408347e037ac101ac58"
    sha256 cellar: :any,                 monterey:       "213812e6348e71cd243b29218b09b1685006c5c8059e8c11150710392a07cadd"
    sha256 cellar: :any,                 big_sur:        "d535f35c20b2f0d1ef3db8814764b42cf18d7c432d946742c81615170c88e22f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a499eb8cfde3ece5750719ccf209c1d6e91e49caa2b461701986562f025f9c"
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

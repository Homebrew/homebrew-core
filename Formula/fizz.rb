class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.06.26.00/fizz-v2023.06.26.00.tar.gz"
  sha256 "e7e53634bfa277b65503bfb21947d09aedde0470124f68ed6782126f943bbdb6"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d5343ee37d44741ffbf380e4709b96ab616fe0ff565ff1d164442f140e24ef45"
    sha256 cellar: :any,                 arm64_monterey: "760d603fc2bb16f96dc62c75973713ee4c1142c688f1a7b3ea6c9820e0e234dc"
    sha256 cellar: :any,                 arm64_big_sur:  "b36051a149b76d43f446a80b612df564000b22e40197318aab636cd2049aa53c"
    sha256 cellar: :any,                 ventura:        "5abc4d9765f7736c8b1d833ac9ca044ce5294f403c7fefa4ca446d2cd3e77733"
    sha256 cellar: :any,                 monterey:       "71ba4403bd063a49a7a88c55c975ee6de32bbe9fae06e890ced1b5609615925d"
    sha256 cellar: :any,                 big_sur:        "d16266e674d988ac0ea346a5d00470b18bcab10adf1a2e6cc030e79e9f58b2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de219193ba104bcd0fc2c7445db81688cfc186e5dae737895614cdc9ae76d6ed"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.01.16.00/fizz-v2023.01.16.00.tar.gz"
  sha256 "879c0fb260bcb0d9d1f6cf92e81353db99dcd7bf1e9c5a9af714cf041f320715"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f7005c22b4e4c62464743e6c4268d975ab1a2d547faac794df982d1d5d99bc2"
    sha256 cellar: :any,                 arm64_monterey: "9da335dd208e0f1406a3ad8da3d1e74c5bf32b35d68844d7d8b4feffd87a2f6e"
    sha256 cellar: :any,                 arm64_big_sur:  "6e0ceea4d1e4062d1ec0b986b3482ed760ca71050b2b5960253cac118c1e82ad"
    sha256 cellar: :any,                 ventura:        "fe9d7ff84e282c32cdbc33652841c93ac792c3c5ddee4d0af0afdf40efcae900"
    sha256 cellar: :any,                 monterey:       "98ba88f398c043c35dfebb5dd29d537e72d36e9b82133d986164dc773bb274d9"
    sha256 cellar: :any,                 big_sur:        "fd87604ccfd380d458f01c4f47f60b0981a4d529f87a5341aabef7525f98dcf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0890d8c14d4f885ae5c2520f849d978add4b9520c55154240525a3c89dfde89"
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

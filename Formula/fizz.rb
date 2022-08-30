class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.08.29.00/fizz-v2022.08.29.00.tar.gz"
  sha256 "1a58eec472a195cf0a1834deb084a9ab832d08f51130f2416183835e19cd1a68"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2b20ae49dd9d5997f0be0e87e6c4e542c546391d4e21b13c077fd99ed26e1a1e"
    sha256 cellar: :any,                 arm64_big_sur:  "4466807e857b3000bc33957a3ba5399f9bdc768bceef56306c19f1854116afb8"
    sha256 cellar: :any,                 monterey:       "8b95c487135f32ada6c056ee2f642067a701cee6029fa7eea2fda2a11e3a9a05"
    sha256 cellar: :any,                 big_sur:        "e6729a9ad3ef0791e577c0316712bde877677174be1204fd56f2ad0867af764c"
    sha256 cellar: :any,                 catalina:       "3d67c1310a8f30bff6e79526df3a9777f800475dffc37db3056c525609dceeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9389784a6afa4113a549dcb59c20190ffc0babd5438cb15c52be7cfa37d80f"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []
    args << "-DLIBRT_LIBRARY=/usr/lib/x86_64-linux-gnu/librt.so" if OS.linux?

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
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

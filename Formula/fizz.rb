class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.05.22.00/fizz-v2023.05.22.00.tar.gz"
  sha256 "3b6ca4f5bd52f54c043c6a3ebf8a30289817780d199b4150e47b02596f4c0a1f"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3dc605ba636f80ab9b940fb46c9b57368731c3c042939a3fca8fecf3349d93b"
    sha256 cellar: :any,                 arm64_monterey: "fa1a82ec59dd0abe8e926941742454d02e53bc0601bfe499c2a0103a8fd79ea1"
    sha256 cellar: :any,                 arm64_big_sur:  "e08af4353d28fd707989f3b0b9cdb653b78b905626cf95b8382196186f949361"
    sha256 cellar: :any,                 ventura:        "4747533e1c87c5b3f5bf82a05535b555d9f0e36b84e3790c327f4795cde824ba"
    sha256 cellar: :any,                 monterey:       "89142eeef4acca1266d7a5d2d1f286968a8a9ab6ac29f582f44a89b9b0e1238e"
    sha256 cellar: :any,                 big_sur:        "325f20f28eedcb9f8385545d10287140eeed8d023b734f2017f058270356f1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d968b93f274a1f93c433350f8eeb9a5300e669e01e4b288b205f1edd22ccf8b"
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

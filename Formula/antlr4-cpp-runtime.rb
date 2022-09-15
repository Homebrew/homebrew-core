class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.11.1-source.zip"
  sha256 "8018c335316e61bb768e5bd4a743a9303070af4e1a8577fa902cd053c17249da"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c1547b153ab1d97b6a4fba9bf14a8c5acb0e751ea0da3e46a697d2529945e2e0"
    sha256 cellar: :any,                 arm64_big_sur:  "d01919370e82df5b4b8bc8bd83f294172ec928f97551b683838faaf660d37828"
    sha256 cellar: :any,                 monterey:       "99440f165a6980709e28ea5c92a2bd84399db2591fa04aa671743acbb96f5c67"
    sha256 cellar: :any,                 big_sur:        "adbf3cda46f982dcb0c58641150b735a247f991f2095b71cdb3a23f9802bb1ae"
    sha256 cellar: :any,                 catalina:       "d23d17dd6e36ecbc26eb73d7746a17e0740816eaa5d6aed93acd4ef44759f51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a082f47b7b07956161836f4e6976933d8c7c608796840515553b512b38d11012"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DANTLR4_INSTALL=ON", "-DANTLR_BUILD_CPP_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <antlr4-runtime.h>
      int main(int argc, const char* argv[]) {
          try {
              throw antlr4::ParseCancellationException() ;
          } catch (antlr4::ParseCancellationException &exception) {
              /* ignore */
          }
          return 0 ;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

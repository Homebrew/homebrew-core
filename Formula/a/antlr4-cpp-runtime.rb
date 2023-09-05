class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.13.1-source.zip"
  sha256 "d350e09917a633b738c68e1d6dc7d7710e91f4d6543e154a78bb964cfd8eb4de"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d45d015de7e2bd862ed904ed88374553327bf4a4e2c9d0d7eb34500465a7834"
    sha256 cellar: :any,                 arm64_monterey: "297906e04b7d3784f31d25e9fde214a928f070fb80923bc974d446c5f25e6bd3"
    sha256 cellar: :any,                 arm64_big_sur:  "64917cc9322bcd9ad9ddfd76ed95735deccadb4ea73f332264b2a5d554a3e2d4"
    sha256 cellar: :any,                 ventura:        "a291d3a2e51595f49c1cb3d76474825ef15091e1c8ab9bb5021b58fec50e9388"
    sha256 cellar: :any,                 monterey:       "75a51fa0a6999b6afb90f62659e80904c799c5b018f41821c4f2bd1fe3ca0c80"
    sha256 cellar: :any,                 big_sur:        "670e3b11a40281c0270dad7f2d7bf6fc9cb741931e0c956a15e6adf2b63d4bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a07f086d1449687c942c93e12fb42bfafc47e9a9a130539e71ae86ed3b7915a3"
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

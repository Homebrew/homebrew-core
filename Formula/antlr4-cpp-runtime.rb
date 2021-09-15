class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.9.2-source.zip"
  sha256 "838a2c804573f927c044e5f45a8feb297683a7047ab62dfac8ddc995498db11c"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2675f194768a527b27fb7423a2cd13d449d7102f87a84648dc3dee4c9a5a2ef1"
    sha256 cellar: :any,                 big_sur:       "1a0ecd0f7f72c1ec539b5e827d4249d163a648678fe236697a78a4acb05e3766"
    sha256 cellar: :any,                 catalina:      "8d4d96b21b91529016470d651680f6c90f02854e7b0fa1569570c9c830da0c6b"
    sha256 cellar: :any,                 mojave:        "e9c6ac2f0d41c5e4c69894e6c4fdfb079693eaa0f297a013a66487339439c164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c5b79c485d2af18036f370291f4ca452f398ad85556ff1260d91b5eadaa0a8"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", "-DANTLR4_INSTALL=ON", *std_cmake_args
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
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

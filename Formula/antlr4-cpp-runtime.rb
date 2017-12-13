class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "http://www.antlr.org"
  url "http://www.antlr.org/download/antlr4-cpp-runtime-4.7.1-source.zip"
  sha256 "23bebc0411052a260f43ae097aa1ab39869eb6b6aa558b046c367a4ea33d1ccc"

  bottle do
    cellar :any
    sha256 "613f3710fe14099054bf112b647dd4e9c62990b5164135d048d9a1002e542836" => :high_sierra
    sha256 "5234bcb1f4db6ef16b1f5921d9992fba3778099bc7a9692ae35c10157478498e" => :sierra
    sha256 "7e9caa8a5dce7785e6d9769747fd5e21c91391237caf64632d21a6975f09336a" => :el_capitan
    sha256 "b8ad063314e460e17e18def0d963c8cc644c93133b75949dcc641eecef16125b" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc", "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

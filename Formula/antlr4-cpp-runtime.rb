class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.7.2-source.zip"
  sha256 "8631a39116684638168663d295a969ad544cead3e6089605a44fea34ec01f31a"

  bottle do
    cellar :any
    sha256 "32a727160b70da2c02d4c0e2cc16edf2f4e598689c261d0198a71a126820035b" => :catalina
    sha256 "61e3aedd11c8ed9dda57ff30f67966c178c1209ba847c44d8db686b9691e645c" => :mojave
    sha256 "3a7b6fd7bd3a8aa81c4844f9c6544f96072e6cc95f5ff4cfa6d0cf8dc5af843d" => :high_sierra
    sha256 "035803548352d0189b5d2a6d3e736cacd64b8a86896fabf87e02b274b89068c3" => :sierra
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
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

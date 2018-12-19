class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.7.2-source.zip"
  sha256 "8631a39116684638168663d295a969ad544cead3e6089605a44fea34ec01f31a"

  bottle do
    cellar :any
    sha256 "7c55dcee97d1d509f6f602a2e4002ec6df85a1bab231284c343e22a917aa41eb" => :mojave
    sha256 "bdb81df9b567f1d0584712616f4e5e8d4028c0875c79c0e4479e3db98be498f7" => :high_sierra
    sha256 "3b41cda988528eaa6f9c8792464f5a71786674774dc3ab370b6bb1171d5758cb" => :sierra
    sha256 "5cc0d3c4ef8111228b058c52a1645168d772d797ed2cbf7747f38d1803c08dc9" => :el_capitan
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

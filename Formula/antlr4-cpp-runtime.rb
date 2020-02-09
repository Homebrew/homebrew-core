class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.8-source.zip"
  sha256 "58c9c8f83ed2b2224a047a2ca8af8c7ca2f45bc13ff30bd8777ce65ba81d6d11"

  bottle do
    cellar :any
    sha256 "e1d273ddfa0ec6d39e6ec23765d4d91951c3089e125bfc65446826be88d534a8" => :catalina
    sha256 "842bcfe3342c504c3beac893f279c9636a6416d7fa45e2335c5d23189543a459" => :mojave
    sha256 "6a20c7dde2c45917fcdc158bfafd6b732c0431045125270b4e651e3f36ac3f39" => :high_sierra
  end

  depends_on "cmake" => :build

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

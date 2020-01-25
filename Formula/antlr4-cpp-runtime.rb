class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.8-source.zip"
  sha256 "58c9c8f83ed2b2224a047a2ca8af8c7ca2f45bc13ff30bd8777ce65ba81d6d11"

  bottle do
    cellar :any
    sha256 "40aa6419b8a856de8aa1b4cf35fb1489b31b83484601fa880a1778dc4d024c22" => :catalina
    sha256 "630bdee3d0ad206b0c22121042d20d1ecc87a3064e7f3068b357d696655f8701" => :mojave
    sha256 "ede763ad82c26dad7903ebf22cc3b99a39be3a0c0d1dd93ca72cb48c41d7a121" => :high_sierra
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

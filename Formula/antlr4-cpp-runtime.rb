class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.9.1-source.zip"
  sha256 "21647f9d5c55d13f2297e3f61e5dd68283e439983c27bd899f9c8a725bbea7b5"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download/"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    cellar :any
    sha256 "7eba6396f9ee8296e836118c91754652f02866c01d1413bd3ce9f65f98144164" => :big_sur
    sha256 "6def4677006825dc6d66c222d0b4ca400b8a8361577e9cb5d1c15e7ff32953bf" => :arm64_big_sur
    sha256 "d16dbd88b32577a5eedecfd6e9c9e7f704fc344477dfbc997c88549f0d44f43a" => :catalina
    sha256 "2048b1ea9f2d661f55819e1aa4c9ee7ca8bcccfee7717b5be6bfb9149ac12574" => :mojave
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

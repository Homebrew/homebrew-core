class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.10.1-source.zip"
  sha256 "2a6e602fd593e0a65d8d310c0952bbdfff34ef361362ae87b2a850b62d36f0b6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c513a0222e04b43c0013ac15a77d2acef6890f2e7fbbdb42a264e4143ecaa5a1"
    sha256 cellar: :any,                 arm64_big_sur:  "6ab56cd232ca4f01aeb3f2525bf2b3f973e14629f0064b8e0760b450df51eaa1"
    sha256 cellar: :any,                 monterey:       "d06a0114f1d079d7b5f29ae64ebdf1868eb7b9f04410e049161226a2a1e76d6c"
    sha256 cellar: :any,                 big_sur:        "024707eebab37c6f5504ca3a4f2e81d4869e084208c6733bc14c8b6341472515"
    sha256 cellar: :any,                 catalina:       "2fd4f6cb6c5d2580e32d177ae6ef8c8e67be0e23768b19cc27f5796b0cba25f9"
  end

  depends_on "cmake" => :build

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

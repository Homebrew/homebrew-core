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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c513a0222e04b43c0013ac15a77d2acef6890f2e7fbbdb42a264e4143ecaa5a1"
    sha256 cellar: :any,                 arm64_big_sur:  "6ab56cd232ca4f01aeb3f2525bf2b3f973e14629f0064b8e0760b450df51eaa1"
    sha256 cellar: :any,                 monterey:       "d06a0114f1d079d7b5f29ae64ebdf1868eb7b9f04410e049161226a2a1e76d6c"
    sha256 cellar: :any,                 big_sur:        "024707eebab37c6f5504ca3a4f2e81d4869e084208c6733bc14c8b6341472515"
    sha256 cellar: :any,                 catalina:       "2fd4f6cb6c5d2580e32d177ae6ef8c8e67be0e23768b19cc27f5796b0cba25f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f86b03137aad378c8640cc49c7f07bb1634e735784183e6fa593f76c50a3ee"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
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

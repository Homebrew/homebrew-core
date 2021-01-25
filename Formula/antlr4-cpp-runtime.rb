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
    sha256 "cc6ef2185004324fd875f69d36246b5f725af58df2111610944dfb0ec6676eb0" => :big_sur
    sha256 "f0f0ff88d204270184f93bf00884d36e85c5ffe544422a70a618b344f0ac60ab" => :arm64_big_sur
    sha256 "9715854b6b78ee74ddd122e4a0e8945da5aa7b9eb7aa60bfe5bfb0e9cd0cd1b8" => :catalina
    sha256 "508dd4e8960a31421f8727aa9b3ae39157a88ad8dcf45e98c9359539964e7bcc" => :mojave
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

class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.12.0-source.zip"
  sha256 "642d59854ddc0cebb5b23b2233ad0a8723eef20e66ef78b5b898d0a67556893b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3438cd9ea3628bd4225bf29540a3c65ca917dc010af271e59cd4b1b6a58dac03"
    sha256 cellar: :any,                 arm64_monterey: "0d3665ac36ff099aabc76da5efbdc35df244a105f14f81ad920934f0872dcbdb"
    sha256 cellar: :any,                 arm64_big_sur:  "7e7032483b95b6286fc4c27ee158c37cbb5840fc53d854904277ebdd3fed041c"
    sha256 cellar: :any,                 ventura:        "769ddfe6ba0f90416ce73584bb203c1f78109f26edb6f252d977710bc23a8d83"
    sha256 cellar: :any,                 monterey:       "3ce1959cc02a180806e5c989b65c17cd1c8c5308a7fdf568150940efc92a6549"
    sha256 cellar: :any,                 big_sur:        "80318c3d31be4b280796bd2c5f19de9bcf8a785d1fa01f20a5d33debb8544eb6"
    sha256 cellar: :any,                 catalina:       "941580a718d7e380cbe6a186eb266b797d59393fb598fd6079e42cd689fd7633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d758da9988efc719a29740af5655435bcd90ea92824b3c3c1a7558d33a29de79"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
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

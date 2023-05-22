class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.13.0-source.zip"
  sha256 "2e5db62acdca9adc3329c485c3b9ce3029e40d13cc9c3e74ced354e818cb63e9"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20b274eaf7c4361628f3dad30601713286db8c2f35ad69bc156085ed9a7be2a0"
    sha256 cellar: :any,                 arm64_monterey: "c043aedbfad3ddaf11493ced1f11b05336dd4d74a024d3e39315e1817ad6dcc1"
    sha256 cellar: :any,                 arm64_big_sur:  "d1458bcc4aa241b6710155e27924ac9bf432aa5f9ad4ede8d0a558170a55c954"
    sha256 cellar: :any,                 ventura:        "fab801a58d218eaa743e7599df628a6962f5e93e77c4dce31b22339950257a4c"
    sha256 cellar: :any,                 monterey:       "244eee75564a6abed381510b8ae8184595774bb86fb85b13767e3cc7a30f8ce8"
    sha256 cellar: :any,                 big_sur:        "3a86f2d6672246c84233012ead14c256548989c41089451490dfea25b000f208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f0480e9a2cb4afa911b52c70c4346bbea34eac91d2e81b768ccec94ce687b4"
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

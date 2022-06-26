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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "12da241d8e8920330781f9a19adc9c4b4ec5fa9a66563ed9452ee5a57dde548f"
    sha256 cellar: :any,                 arm64_big_sur:  "2b0b14e5bd3598c628f307f22a48667f11e96a5b38dac86ac03b7b4f27b21b85"
    sha256 cellar: :any,                 monterey:       "c7e00adc82d2f850f2aaf2ca0cd483eee0302ea4372d1d9bdf233ba26787ce6e"
    sha256 cellar: :any,                 big_sur:        "a948bd5d0bc16022f9923ad4c906e2c2ee87562de55598cd17cbc620d3e909d6"
    sha256 cellar: :any,                 catalina:       "ae1bc67f019cd414895b69636633e013bc6acc2ccbba1eb1a5fd73ec36e2a5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699382d0976f8fd084012b4e5ab1dc6ff928653f644e98850cbeffe8a99561e6"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "util-linux"
  end

  fails_with gcc: "5"

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
    system ENV.cxx, "-std=c++17", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

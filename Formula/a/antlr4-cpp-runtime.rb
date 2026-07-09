class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.13.2-source.zip"
  sha256 "0ed13668906e86dbc0dcddf30fdee68c10203dea4e83852b4edb810821bee3c4"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68f3e05f2ec65f4b039a3381102d3a470be23033a934ff1cb0a7897c5d6bd019"
    sha256 cellar: :any,                 arm64_sequoia: "b1444f15d65fb7fbb4da3a05739b00b289535261b973cf5d9c0d0e8277aeb197"
    sha256 cellar: :any,                 arm64_sonoma:  "e2c896d67ebf8ff81660cc3650e84c2e8084de16c4bd982c6d5165426b15d3ec"
    sha256 cellar: :any,                 sonoma:        "9976b623aca8022951150dabf94113fe87853c7c85c4d7bf8c9d7ed46beae583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "996e85cb2900cd345d7750aab49167b89fe9eb9a098172a99ab8ff825278e5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01e069c449950cb7b6ce81e20a6e91dba6de3150f057337a12bb6a283ce96c06"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %w[
      -DANTLR4_INSTALL=ON
      -DANTLR_BUILD_CPP_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <antlr4-runtime.h>
      int main(int argc, const char* argv[]) {
          try {
              throw antlr4::ParseCancellationException() ;
          } catch (antlr4::ParseCancellationException &exception) {
              /* ignore */
          }
          return 0 ;
      }
    CPP
    system ENV.cxx, "-std=c++17", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

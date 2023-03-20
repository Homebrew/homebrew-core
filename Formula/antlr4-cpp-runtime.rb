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
    sha256 cellar: :any,                 arm64_ventura:  "63c1572cf3f7cdac8b8600ad77019ad952126aaaec51d57556fbeedeba5c445a"
    sha256 cellar: :any,                 arm64_monterey: "d28077a96b19ef54447d26b6ff75b116a2ad27eda2fd2fdbb36e701d5ce6db4a"
    sha256 cellar: :any,                 arm64_big_sur:  "af4be2d849d147ebd838d7d244d117ac1e9947c444b304f522ec6f3a37371f04"
    sha256 cellar: :any,                 ventura:        "335105d75a083880e9561ae2211f4bb83a7c347477f588e656c21b2191cebad5"
    sha256 cellar: :any,                 monterey:       "de063ada35e592f9a6a1ec1a903cca0410da79074550cfb5192b915d8a617e1e"
    sha256 cellar: :any,                 big_sur:        "5f40c465db117017ae8c4e21ddb9b02108a9996cab654d789e08a61b522f2a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29014e67b7440a5f88b99a9e6c6af34e0930c5c7e3e9910bd8fc4b023dfd36fb"
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

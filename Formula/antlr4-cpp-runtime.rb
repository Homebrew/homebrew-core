class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.9.3-source.zip"
  sha256 "5f0af6efd81f476c3e775c486eb0a71c25d6bbc14373e88a64690e2738d68e03"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b828aa3edfd6a877b7305e891ddcef3139f065d3fed62d4019c8dc647df342d1"
    sha256 cellar: :any,                 arm64_big_sur:  "bb6f0596a63a9efcdebb911d1e89199acc7ba51f830832370c7eacd70d3c592f"
    sha256 cellar: :any,                 monterey:       "24fedc44d4b5cd54807e2e0a4a2ecb7210278a8041323a8ab3272e4dd95490ef"
    sha256 cellar: :any,                 big_sur:        "7dc07a14640606dd93e844b537a791695900fcb9682c9b29b25d75b4879fc144"
    sha256 cellar: :any,                 catalina:       "b9757ab1d9c97d6295f1267ed90ae1fc9c115bdbee528d80478dc329fa23d546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3655a8edd62c4afeb7e4884232240108590453b913b019f4127f4ebfcb6a707e"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

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

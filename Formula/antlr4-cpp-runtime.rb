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
    sha256 cellar: :any,                 arm64_monterey: "7a636ac028a5bfaa9448a32b7bac3804c15454e3e98d104dd0ab9b3f597e4f5f"
    sha256 cellar: :any,                 arm64_big_sur:  "416344a57f99b82ee473b2586f2987e7d9b33d84904d10e3385f6e376a48f424"
    sha256 cellar: :any,                 monterey:       "a5d02f022d3969f58b6e951d2342a319b03bc88f417029ed5427996ebb5da9fb"
    sha256 cellar: :any,                 big_sur:        "a43fd050ed2bd66bb9fcf163ea7e9f1974b60a71fefda42666b6940d50ecaeb1"
    sha256 cellar: :any,                 catalina:       "ab2235f34b79e240f159d1263f2d900a91994091af6c69b3147df094435264a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8068ef89deda3faee3d3a26dfc6bed5a1260330f662d82a370fa6a59edd0d90"
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

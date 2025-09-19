class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.13.2-source.zip"
  sha256 "0ed13668906e86dbc0dcddf30fdee68c10203dea4e83852b4edb810821bee3c4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d8f9d672ccd25be18abca3d12219ba53c3d797a75c41c9616ed7b741f28699ca"
    sha256 cellar: :any,                 arm64_sequoia:  "2094de636c5aed0176c2a9719a92554cf839b17b047e2792c300e1207225074b"
    sha256 cellar: :any,                 arm64_sonoma:   "d27c1a0fe28b968a40cab91183d1b0c3a681d3c287bf25dd6e4b0e59ba991af6"
    sha256 cellar: :any,                 arm64_ventura:  "4d6a9dca9ad714531d45d853e6d01f00d9e8181b345dd53584d25d5162693a92"
    sha256 cellar: :any,                 arm64_monterey: "7ce24e3fcb89f34345a3cb596e2e7616af56e376c0137a58ee090f3d3ddcb3cd"
    sha256 cellar: :any,                 sonoma:         "5a36907fcc647e852ae13c9cd51bcc4ccb8ec91d89b0c618c838006ca60d1be0"
    sha256 cellar: :any,                 ventura:        "252ce01a63a080f19c9366be691a41faec552205d4497591b6c128c6d36a69d6"
    sha256 cellar: :any,                 monterey:       "d35b13d3122b481810c4a1edebf2add904647c0c96d431584a633cafa8aa4897"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "47c1f68ced83aed06e56f01a7630253bbf11d7a9ad275d81645e420d150e1ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04da1cc9e4e3b28751460f84ebe762a1ac566db6d620568813ba8bf1a039acec"
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

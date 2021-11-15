class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https://cliutils.github.io/CLI11/book/"
  url "https://github.com/CLIUtils/CLI11/archive/v2.1.2.tar.gz"
  sha256 "26291377e892ba0e5b4972cdfd4a2ab3bf53af8dac1f4ea8fe0d1376b625c8cb"
  license "BSD-3-Clause"
  head "https://github.com/CLIUtils/CLI11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a656ae71a93d5adb93e5b7b83a19c108f7c959ad0b403385b1efe5559d30376"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCLI11_BUILD_DOCS=OFF", "-DCLI11_BUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "CLI/App.hpp"
      #include "CLI/Formatter.hpp"
      #include "CLI/Config.hpp"

      int main(int argc, char** argv) {
          CLI::App app{"App description"};

          std::string filename = "default";
          app.add_option("-r,--result", filename, "A test string");

          CLI11_PARSE(app, argc, argv);
          std::cout << filename << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo\n", shell_output("./test -r foo")
  end
end

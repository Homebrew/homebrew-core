class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https://cliutils.github.io/CLI11/book/"
  url "https://github.com/CLIUtils/CLI11/archive/v2.3.2.tar.gz"
  sha256 "aac0ab42108131ac5d3344a9db0fdf25c4db652296641955720a4fbe52334e22"
  license "BSD-3-Clause"
  head "https://github.com/CLIUtils/CLI11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d5ba7a68bb33ef0ba52b9d8d60cf1cbe3a608def227663bd3d3940ec52c22bd"
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

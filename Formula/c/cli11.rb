class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https://cliutils.github.io/CLI11/book/"
  url "https://github.com/CLIUtils/CLI11/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "c6ea6b2e5608b3ea8617999bd5f47420c71b2ebdb8dc4767c1034d1da5785711"
  license "BSD-3-Clause"
  head "https://github.com/CLIUtils/CLI11.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f04181692a4d3389a7b03d14388607b5eaac5742d9761cc8c447a5df5416ab75"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCLI11_BUILD_DOCS=OFF
      -DCLI11_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo\n", shell_output("./test -r foo")
  end
end

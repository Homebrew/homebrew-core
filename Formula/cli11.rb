class Cli11 < Formula
  desc "Simple and intuitive command-line parser for C++11"
  homepage "https://cliutils.github.io/CLI11/book/"
  url "https://github.com/CLIUtils/CLI11/archive/v2.3.1.tar.gz"
  sha256 "378da73d2d1d9a7b82ad6ed2b5bda3e7bc7093c4034a1d680a2e009eb067e7b2"
  license "BSD-3-Clause"
  head "https://github.com/CLIUtils/CLI11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db9939e28a25e0d3be83114e856caaea4469fc0b80627b6a763cb7e6a6de996c"
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

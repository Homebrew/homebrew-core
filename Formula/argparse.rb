class Argparse < Formula
  desc "Argument Parser for Modern C++"
  homepage "https://github.com/p-ranav/argparse"
  url "https://github.com/p-ranav/argparse/archive/refs/tags/v2.9.tar.gz"
  sha256 "cd563293580b9dc592254df35b49cf8a19b4870ff5f611c7584cf967d9e6031e"
  license "MIT"
  head "https://github.com/p-ranav/argparse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b06b4b33d861e3940c10cfcebc48c96a7154bd0495beb206206ac39e0c7e5fb2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <argparse/argparse.hpp>

      int main(int argc, char *argv[]) {
        argparse::ArgumentParser program("test");

        program.add_argument("--color").default_value(std::string{"orange"});
        program.parse_args(argc, argv);

        auto color = program.get<std::string>("--color");
        std::cout << "Color: " << color;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "Color: blue", shell_output("./test --color blue").strip
  end
end

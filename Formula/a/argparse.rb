class Argparse < Formula
  desc "Argument Parser for Modern C++"
  homepage "https://github.com/p-ranav/argparse"
  url "https://github.com/p-ranav/argparse/archive/refs/tags/v3.0.tar.gz"
  sha256 "ba7b465759bb01069d57302855eaf4d1f7d677f21ad7b0b00b92939645c30f47"
  license "MIT"
  head "https://github.com/p-ranav/argparse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83247bc96ba531d3c00bedb4ff57b5c704e33ab3e2fa53eb2ef82385f99bd022"
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

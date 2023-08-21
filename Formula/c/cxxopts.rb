class Cxxopts < Formula
  desc "Lightweight C++ command-line option parser"
  homepage "https://github.com/jarro2783/cxxopts"
  url "https://github.com/jarro2783/cxxopts/archive/v3.1.1.tar.gz"
  sha256 "523175f792eb0ff04f9e653c90746c12655f10cb70f1d5e6d6d9491420298a08"
  license "MIT"
  head "https://github.com/jarro2783/cxxopts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e30467154ef8fa8e4df574b63c6169e25b5b86f0e076c9c01e3bdedbaf9d3f42"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCXXOPTS_BUILD_EXAMPLES=OFF",
                            "-DCXXOPTS_BUILD_TESTS=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cstdlib>
      #include <cxxopts.hpp>

      int main(int argc, char *argv[]) {
          cxxopts::Options options(argv[0]);

          std::string input;
          options.add_options()
              ("e,echo", "String to be echoed", cxxopts::value(input))
              ("h,help", "Print this help", cxxopts::value<bool>()->default_value("false"));

          auto result = options.parse(argc, argv);

          if (result.count("help")) {
              std::cout << options.help() << std::endl;
              std::exit(0);
          }

          std::cout << input << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-o", "test"
    assert_equal "echo string", shell_output("./test -e 'echo string'").strip
    assert_equal "echo string", shell_output("./test --echo='echo string'").strip
  end
end

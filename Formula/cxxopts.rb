class Cxxopts < Formula
  desc "Lightweight C++ command-line option parser"
  homepage "https://github.com/jarro2783/cxxopts"
  url "https://github.com/jarro2783/cxxopts/archive/v2.2.0.tar.gz"
  sha256 "447dbfc2361fce9742c5d1c9cfb25731c977b405f9085a738fbd608626da8a4d"
  head "https://github.com/jarro2783/cxxopts.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d218ecd42f83ea5e0fac4c6d8e36d5acf555133c7d52fed9657107edffef917" => :mojave
    sha256 "0d218ecd42f83ea5e0fac4c6d8e36d5acf555133c7d52fed9657107edffef917" => :high_sierra
    sha256 "36f6ff18ae628891ca7d188c749fea2a097db1b9d83181bfd123ce09adddebb3" => :sierra
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

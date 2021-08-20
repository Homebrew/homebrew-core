class Cxxopts < Formula
  desc "Lightweight C++ command-line option parser"
  homepage "https://github.com/jarro2783/cxxopts"
  url "https://github.com/jarro2783/cxxopts/archive/v2.2.1.tar.gz"
  sha256 "984aa3c8917d649b14d7f6277104ce38dd142ce378a9198ec926f03302399681"
  license "MIT"
  head "https://github.com/jarro2783/cxxopts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dffc57a1cc6de42f042163c6d44e42e24a778bd1cdf7f7e45e96f9b07b64880c"
    sha256 cellar: :any_skip_relocation, big_sur:       "40c3c76fe2008d8a31f51748970af0873b622d3540ccde6462caac0e1322fbca"
    sha256 cellar: :any_skip_relocation, catalina:      "d4a289fb314e5efdb8c889c560340c259c04b19b9d1e7087b58d0d24aafd5ed2"
    sha256 cellar: :any_skip_relocation, mojave:        "d4a289fb314e5efdb8c889c560340c259c04b19b9d1e7087b58d0d24aafd5ed2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d4a289fb314e5efdb8c889c560340c259c04b19b9d1e7087b58d0d24aafd5ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e201e81cc6246a4691bb97168dfab6bd5bcdde73cccd1ac702079be15463715a"
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

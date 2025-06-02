class Cxxopts < Formula
  desc "Lightweight C++ command-line option parser"
  homepage "https://github.com/jarro2783/cxxopts"
  url "https://github.com/jarro2783/cxxopts/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "3bfc70542c521d4b55a46429d808178916a579b28d048bd8c727ee76c39e2072"
  license "MIT"
  head "https://github.com/jarro2783/cxxopts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24dcb23b8d9c163a1db1ebdb1876bb1158e2116bd1f8e10bb779f5c3644cc222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24dcb23b8d9c163a1db1ebdb1876bb1158e2116bd1f8e10bb779f5c3644cc222"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24dcb23b8d9c163a1db1ebdb1876bb1158e2116bd1f8e10bb779f5c3644cc222"
    sha256 cellar: :any_skip_relocation, sonoma:        "24dcb23b8d9c163a1db1ebdb1876bb1158e2116bd1f8e10bb779f5c3644cc222"
    sha256 cellar: :any_skip_relocation, ventura:       "24dcb23b8d9c163a1db1ebdb1876bb1158e2116bd1f8e10bb779f5c3644cc222"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26270aee8d41222b9753788ac2f05fff7b82f5cade93bc8c5001fb5aa790d602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26270aee8d41222b9753788ac2f05fff7b82f5cade93bc8c5001fb5aa790d602"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCXXOPTS_BUILD_EXAMPLES=OFF
      -DCXXOPTS_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-o", "test"
    assert_equal "echo string", shell_output("./test -e 'echo string'").strip
    assert_equal "echo string", shell_output("./test --echo='echo string'").strip
  end
end

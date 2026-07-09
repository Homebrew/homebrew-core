class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.3.tar.gz"
  sha256 "6bd077062761e18881b5d4a300993243c09730f0cda449a9920333db6e1fccdd"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a38a3060972f892635f0a519f0d406cdfd52b38b8f80c545de2cb8c6ebf32e64"
    sha256 cellar: :any, arm64_sequoia: "7d655e8fe427dbd9a148f3cc6474bd52faf31ec178d17210a36a38519c216b84"
    sha256 cellar: :any, arm64_sonoma:  "84589f3c95cda0f40600ca849a5273943980e1464e4e05c9a281d3db50c12dfb"
    sha256 cellar: :any, sonoma:        "7a5eebe83e9ad760ec60f00ebb54fb836db3d46badf62f8077f9306fe12c37a5"
    sha256 cellar: :any, arm64_linux:   "eeb4e3e1566b073f1ccfc5571ab5ec56ab984ec643a4f91106d0ca5173555f77"
    sha256 cellar: :any, x86_64_linux:  "c0b8afd94dc6897215f58f494ea18986fb989b98d93f4f85046d1bb4af91c506"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "llvm"
  depends_on "yaml-cpp"

  def llvm
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux? && llvm.versioned_formula?
    args = %w[
      -DBUILD_TESTS=OFF
    ]

    # If '.git' directory is not available during build, we need
    # to provide the version using a CMake option
    args << "-DGIT_VERSION=#{version}" if build.stable?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "packaging/autocomplete/clang-uml"
    zsh_completion.install "packaging/autocomplete/_clang-uml"
  end

  test do
    # Check if clang-uml is linked properly
    system bin/"clang-uml", "--version"
    system bin/"clang-uml", "--help"

    # Initialize a minimal C++ CMake project and try to generate a
    # PlantUML diagram from it
    (testpath/"test.cc").write <<~CPP
      #include <stddef.h>
      namespace A {
        struct AA { size_t s; };
      }
      int main(int argc, char** argv) { A::AA a; return 0; }
    CPP
    (testpath/".clang-uml").write <<~YAML
      compilation_database_dir: build
      output_directory: diagrams
      diagrams:
        test_class:
          type: class
          include:
            namespaces:
              - A
    YAML
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)

      project(clang-uml-test CXX)

      set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

      add_executable(clang-uml-test test.cc)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args

    system bin/"clang-uml", "--no-metadata", "--query-driver", "."

    expected_output = Regexp.new(<<~EOS, Regexp::MULTILINE)
      @startuml
      class "A::AA" as C_\\d+
      class C_\\d+ {
      __
      \\+s : size_t
      }
      @enduml
    EOS

    assert_path_exists testpath/"diagrams/test_class.puml"

    assert_match expected_output, (testpath/"diagrams/test_class.puml").read
  end
end

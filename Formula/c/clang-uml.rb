class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.5.5.tar.gz"
  sha256 "95585b59c822f3c135dae04574055384e1f904ac69c75c8570b4eb65eca6fd37"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14b3ad29b42c1c86e0de3681e7207c5e83ef996d3d8f06303deaad0d8ea5869f"
    sha256 cellar: :any,                 arm64_sonoma:  "740293a5bd8a3887c0ae601e721754a6b9d49d9a621e081c565ce0b00ce7080e"
    sha256 cellar: :any,                 arm64_ventura: "fa735fd5af8835a3b170a87fd31c08794d403601e726637b751b1ee266f2d86e"
    sha256 cellar: :any,                 sonoma:        "5c6751a5cbce1640b7b16c28ce1d8d7b7c44b963461ea9a99adc500ec0610e3d"
    sha256 cellar: :any,                 ventura:       "91f342d39e27ee11f5f82fb06659d8948f04609962cc99bf7abc8d9fcf525ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a249d17300e6cfa62dba4babf4e0367c8d4a2aa12e1c8170b5e74337220adae1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "yaml-cpp"

  fails_with gcc: "5"

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
    (testpath/"test.cc").write <<~EOS
      #include <stddef.h>
      namespace A {
        struct AA { size_t s; };
      }
      int main(int argc, char** argv) { A::AA a; return 0; }
    EOS
    (testpath/".clang-uml").write <<~EOS
      compilation_database_dir: build
      output_directory: diagrams
      diagrams:
        test_class:
          type: class
          include:
            namespaces:
              - A
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.15)

      project(clang-uml-test CXX)

      set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

      add_executable(clang-uml-test test.cc)
    EOS

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

    assert_predicate testpath/"diagrams"/"test_class.puml", :exist?

    assert_match expected_output, (testpath/"diagrams/test_class.puml").read
  end
end

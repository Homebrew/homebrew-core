class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.2.tar.gz"
  sha256 "004540c328699f81abebceb33a4661b548ab3a5f74096da2c025b9971b2b17ff"
  license "Apache-2.0"
  revision 3
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09d6e2f4a448df8604d583726c4bc4fad23804c6cb3cb11bcdb4007ebdf2c71f"
    sha256 cellar: :any,                 arm64_sequoia: "8596889c658b3b6695bb5cf5be228046eace2abd2677a0d42a0a7da953c18548"
    sha256 cellar: :any,                 arm64_sonoma:  "a4966abf98faf0a18785840502690082e24e010606ed9ab26476005a858e277d"
    sha256 cellar: :any,                 sonoma:        "1ae21e3d38f4ed9136b5ce7f36690306581114f09412127ca984ef082e027668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1e9e7930ab31e993181bc157bca9c3492522181d20aa64e1a76afebe66139d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053e3c88b09c766f03ff7ce0068399201d1e4c5893f5bf4704f343414365e266"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "llvm@21"
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

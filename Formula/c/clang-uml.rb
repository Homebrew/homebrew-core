class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.3.tar.gz"
  sha256 "6bd077062761e18881b5d4a300993243c09730f0cda449a9920333db6e1fccdd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0973e4c60640441b2437dbf1300330c2edbd15dacd28d91f36fe2002de78dba"
    sha256 cellar: :any, arm64_sequoia: "b0e81d9d8c5bb4b5132d5a2b7a0c2989ab584a7454dc1a740025a51a64ec22b2"
    sha256 cellar: :any, arm64_sonoma:  "53ffcb31c0cb681a84dffc177b313fdcd2c5edfbe382916d575d9a64aa20221e"
    sha256 cellar: :any, sonoma:        "058f3a7265843d4cb03ad3a1297498ac84333c5008680f92ec19aefab854cd12"
    sha256 cellar: :any, arm64_linux:   "9529b1fa7f299dc8c338c521454a85f5ded7ff321edbea04dc2ea6a0602ffc01"
    sha256 cellar: :any, x86_64_linux:  "fbd208536d3b5d16849d7ce2dcfbbf2e0b54033b3d5e3ba5b5c6b1edb82f1b86"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "llvm@22"
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

class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.1.tar.gz"
  sha256 "a64c3cae87a282be207e4c5faf47534dca21b06cb6f463bb7b04de979dccf17e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fd22620d40efe64c0f4b1a480b5971ded072a946a9b9a30867c5ecf115db537"
    sha256 cellar: :any,                 arm64_sonoma:  "327a49a6c41f4a4f178d13bc4a41321c738f28d7dc1b88608912c28575800488"
    sha256 cellar: :any,                 arm64_ventura: "2bb66e775151529dc30f96fde62afda7c936386d75d29ecba8b07123d311674e"
    sha256 cellar: :any,                 sonoma:        "9295ba057159bc80373717119e58ba181bd020267c849b56559b0245871711b3"
    sha256 cellar: :any,                 ventura:       "d22a834e0e6b3fac00fd05b76ad2c46cd0f694d9de6531a6b5ff31fa32b8f444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81908d08a72c9c46a26e1c7f408c85cf408d0938e23bc14cf47a8446998073ef"
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

    assert_path_exists testpath/"diagrams"/"test_class.puml"

    assert_match expected_output, (testpath/"diagrams/test_class.puml").read
  end
end

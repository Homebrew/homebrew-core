class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.2.tar.gz"
  sha256 "004540c328699f81abebceb33a4661b548ab3a5f74096da2c025b9971b2b17ff"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bffe298a11ff65c80dec6b020142fc8b6bc902339316ab07dc40d0702008cb5b"
    sha256 cellar: :any,                 arm64_sonoma:  "050b6a471deca02e968f6422754dad6b8948fa41cec134de0641bd999dca7530"
    sha256 cellar: :any,                 arm64_ventura: "c408164832471352c12b9a8661a4a30b8e2158268daeea3fca6a564d91d9db57"
    sha256 cellar: :any,                 sonoma:        "9fb6817ec6239539a1356e3289ec30ee797c7a10f7010e3833fe98cbc81d8bde"
    sha256 cellar: :any,                 ventura:       "b0c736b7be3eeb4adce9e28d83347dbc815a63062fffd5475e7fd3739f81b42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a8ea5f5257105ee578172a369d445c8b2d497391bc75128557ec1854ca441c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7cb7625ee43e3c100ab2fb9293f85fb9329f528b36fe96b738482418332efc"
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

class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.1.tar.gz"
  sha256 "a64c3cae87a282be207e4c5faf47534dca21b06cb6f463bb7b04de979dccf17e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78792810ae5fa540819d95061fd4c16a3acce6570c191267ea7a31a5c40c4a13"
    sha256 cellar: :any,                 arm64_sonoma:  "a145222bb207e95e0102386b1911148d7ea1be0db1051d20e4a18a7a1f1bf4dc"
    sha256 cellar: :any,                 arm64_ventura: "3cf910c698552bcf4b322ea3588dd3b952773616e30d6feff364a6c9d1b7e42e"
    sha256 cellar: :any,                 sonoma:        "b12708defd94eeb41e5c1af4b8e397483d7444e704b652263949bc41fc00d686"
    sha256 cellar: :any,                 ventura:       "105421cec43a3418a3f46a83cab33805e671014b8be86c8ca83468dcc6ba1ebe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f92f71cc357fabc60d14b08b60cf17807c12339eea355e590c77156e070f205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b66ce132290a5e67e4741d710ea35edee791b9379ae43aacb9c7f403fe3351"
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

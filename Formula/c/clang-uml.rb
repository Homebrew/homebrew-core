class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.0.tar.gz"
  sha256 "df50f715ab4b5f8705893aba45f6146b77cbd1c0653e81e2555772d8584601d5"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef69e10427ae18579ded81c976f7ff99b510b8a259c00537e86c623408b5be58"
    sha256 cellar: :any,                 arm64_sonoma:  "519d24f4f5cf1c8fd66aa25974ae1f22cb2b28d24212c7c257d7614f883572e7"
    sha256 cellar: :any,                 arm64_ventura: "bca97dfb431d4e18fbfdd1a410ac8ed82322f7e1978d9954e313cffdf69043dd"
    sha256 cellar: :any,                 sonoma:        "d25f9faa7cfeafd93066cca12d265a0bd88001e659e458941c4cbab4e4a25c4c"
    sha256 cellar: :any,                 ventura:       "abb5969d6c8223b45daf82408a6ca80bd6f6f0cea2565ba994b17eb9e7ae0864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ea7ee16b42512e71a166f1a8227b2be24a645ae7f50a8b0bfcd9c57ebb617f"
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

    assert_predicate testpath/"diagrams"/"test_class.puml", :exist?

    assert_match expected_output, (testpath/"diagrams/test_class.puml").read
  end
end

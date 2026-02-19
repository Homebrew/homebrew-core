class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.2.tar.gz"
  sha256 "004540c328699f81abebceb33a4661b548ab3a5f74096da2c025b9971b2b17ff"
  license "Apache-2.0"
  revision 2
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8bbf1105ccd85a64f3d63db6ce2ccc09fab47a545f5a97d6f27ffc410a43de0"
    sha256 cellar: :any,                 arm64_sequoia: "f2d67162e85b21b7e278d34bb5ed2a40a0bfff1b5cfc1721b3f3835eed828453"
    sha256 cellar: :any,                 arm64_sonoma:  "b44dda01ec453aa1e4a7445e89a501eb165a5d8d8925aff83ea44cdffd139da1"
    sha256 cellar: :any,                 sonoma:        "16bf8d108060872182e4345a01f7cdf37b72f44e9aec50b04d99be71f98a312c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "392f07fb8cc0a015bd84676333c9078997d3fb615706013f284a51c54ca3a551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0080076a3bcdf10796ddcfd5d7b8069f4d47791e1c99872797c1f0eb44a97899"
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

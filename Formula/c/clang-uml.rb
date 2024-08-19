class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.5.4.tar.gz"
  sha256 "445ae69e9ef7dcc50d0352dcd79d8c55994a7bebd84684f95405fd81168338c4"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca2ac85a447a17f124d9af35041e8135c9accf744ea4fd20f695706f8679104a"
    sha256 cellar: :any,                 arm64_ventura:  "2a883f3fde53ff4c1467348172a79dae3ee2f924006d93164af879ccb544c445"
    sha256 cellar: :any,                 arm64_monterey: "783a0b9f50a1c5b064e1913b4d1a4910e4c4ec4a54ed1efe28ac437a00824fd0"
    sha256 cellar: :any,                 sonoma:         "200736ce230a15a5af25d76b07efff3fe91d14077756b76be8ce401a698998ad"
    sha256 cellar: :any,                 ventura:        "04014ddaf6aec03abf7611453987ba21c734b5c134d51b08a75b612a03fa44ec"
    sha256 cellar: :any,                 monterey:       "33a5a27ed337b5d8f7c8ed1f31c4b95048aa666ab4ee0453bf93bbb8a15d7571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f3a9baf770cdd7cec9ae43c83c558b4cf9cd49621047bbcd9e8fec5ecc42126"
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
    args = %w[
      -DBUILD_TESTS=OFF
    ]

    # If '.git' directory is not available during build, we need
    # to provide the version using a CMake option
    args << "-DGIT_VERSION=#{version}" if build.stable?

    # Use LLVM-provided libc++
    args << "-DCMAKE_EXE_LINKER_FLAGS=-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib} -lunwind" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "packaging/autocomplete/clang-uml"
    zsh_completion.install "packaging/autocomplete/_clang-uml"
  end

  def caveats
    on_macos do
      <<~EOS
        If you see errors such as `fatal: 'stddef.h' file not found`, try
        adding `--query-driver .` to the `clang-uml` command line in order to
        ensure that proper system headers are available to Clang.

        For more information see: https://clang-uml.github.io/md_docs_2troubleshooting.html
      EOS
    end
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

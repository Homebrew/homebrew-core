class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://github.com/bkryza/clang-uml/archive/refs/tags/0.6.2.tar.gz"
  sha256 "004540c328699f81abebceb33a4661b548ab3a5f74096da2c025b9971b2b17ff"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94db4fad5ce558e1a5e168f27b2e376a02fdfa4228974a58f425a2ede82a9152"
    sha256 cellar: :any,                 arm64_sequoia: "1aa0e9d5dc458d3bca6664861311b45e3dcc08a38af59064bc73b5d1d0fdb997"
    sha256 cellar: :any,                 arm64_sonoma:  "9409c54c5f610eac2f82d7da271e3acb10d70779fb0485ef4c91175e19c613ce"
    sha256 cellar: :any,                 arm64_ventura: "e6d5bd9d6d67fd95d41493d856a64599d93a914698e7f336f36b7deaf1142523"
    sha256 cellar: :any,                 sonoma:        "04b037156babbfc2e70fca150f5951175b281f576d13da8fa91aa637747c2bb8"
    sha256 cellar: :any,                 ventura:       "303669e141b74c565d7908a283ae344ac5df43eb5e12eebd2c4d0cb4bbae9059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2607fb8181dff212b77959e57371b6285067db22235a48fba19e0888070bf3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70c49308718e4d29cc4b6b1670b902e596599a87af20563f1af2da2bf4ba0d94"
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

class ClangIncludeGraph < Formula
  desc "Simple tool for visualizing and analyzing C/C++ project include graph"
  homepage "https://github.com/bkryza/clang-include-graph"
  url "https://github.com/bkryza/clang-include-graph/archive/refs/tags/0.2.0.tar.gz"
  sha256 "174bbf961a2426030102bcf444eb2ca4ac10c05cfd5b993fef24bf4d492c420c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/bkryza/clang-include-graph.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c423cbe1c07f46fec7da9366441926e5432b1397cf4089c73eb5f0c8b02b3c35"
    sha256 cellar: :any, arm64_sequoia: "6d72273c3217f8a0bb4a2ed452022f589e0f04f9b916012441e481e28df609ab"
    sha256 cellar: :any, arm64_sonoma:  "9bf1beab39649328eb15ce500637316d62e4a0490c3106b451154b7428efff1f"
    sha256 cellar: :any, sonoma:        "e9c4fb65b8be86416e8d654754423612f82a7842eb1f7d31b4c9433b8bc1bccf"
    sha256 cellar: :any, arm64_linux:   "50dfe4ed236421e9cb31a1c918af2c3ca1d6f8e9b84ed5422e0f9ff35295833c"
    sha256 cellar: :any, x86_64_linux:  "7e8b46b1abc48211e97c88b05a752e5971b01f1ac01d21ff1272133df5c6329e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "llvm"

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
  end

  test do
    # Check if clang-include-graph is linked properly
    system bin/"clang-include-graph", "--version"
    system bin/"clang-include-graph", "--help"

    # Initialize a minimal C++ CMake project and try to generate a
    # PlantUML diagram from it
    (testpath/"test.h").write <<~CPP
      #pragma once
      namespace A {
        struct AA { size_t s; };
      }
    CPP
    (testpath/"test.cc").write <<~CPP
      #include "test.h"
      #include <stddef.h>
      int main(int argc, char** argv) { A::AA a; return 0; }
    CPP
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)

      project(clang-include-graph-test CXX)

      set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

      add_executable(clang-include-graph-test test.cc)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args

    system bin/"clang-include-graph", "-d", testpath/"build", "--plantuml",
      "--relative-to", testpath, "--relative-only", "--output", testpath/"test.puml"

    expected_output = Regexp.new(<<~EOS, Regexp::MULTILINE)
      @startuml
      file "test.h" as F_0
      file "test.cc" as F_1
      F_0 <--  F_1
      @enduml
    EOS

    assert_path_exists testpath/"test.puml"

    assert_match expected_output, (testpath/"test.puml").read
  end
end

class ClangIncludeGraph < Formula
  desc "Simple tool for visualizing and analyzing C/C++ project include graph"
  homepage "https://github.com/bkryza/clang-include-graph"
  url "https://github.com/bkryza/clang-include-graph/archive/refs/tags/0.2.0.tar.gz"
  sha256 "174bbf961a2426030102bcf444eb2ca4ac10c05cfd5b993fef24bf4d492c420c"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-include-graph.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3480c320bbd4af88fc4d12d612c55f4b5f79a9cf4e2479dcc4d9d38ca483acc4"
    sha256 cellar: :any,                 arm64_sonoma:  "2906d24fb1455310992f9003714951dcd9cf2a4f82bdad3bbe454e6e57807fd1"
    sha256 cellar: :any,                 arm64_ventura: "7f7c3547adc92cfc57c56aa46b50a6cf87986a8be3abae841bdf90859aeb7f49"
    sha256 cellar: :any,                 sonoma:        "86d64bd1b27888c88d760ed89e10c061a4b7438d5df5482aedbf249f8f2259f2"
    sha256 cellar: :any,                 ventura:       "5078292a72af6763ea2f6e0cbca879024344a533f4490f19d69ea4b36214168f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43c607758cca6ab5d1842cdf9bb39bc05ea422c2e73c1441f3029ca2e70bbf97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b0b5b89b771bd9d1007e5be39a77f527e7c34be2fa66dc86d1cf1b618487f02"
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

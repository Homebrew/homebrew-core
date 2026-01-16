class ClangIncludeGraph < Formula
  desc "Simple tool for visualizing and analyzing C/C++ project include graph"
  homepage "https://github.com/bkryza/clang-include-graph"
  url "https://github.com/bkryza/clang-include-graph/archive/refs/tags/0.2.0.tar.gz"
  sha256 "174bbf961a2426030102bcf444eb2ca4ac10c05cfd5b993fef24bf4d492c420c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/bkryza/clang-include-graph.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b91cadc2503430beeeb5007a71b88e6876f847f4498f7a03cb73ad4f9108de5f"
    sha256 cellar: :any,                 arm64_sequoia: "53c10e1ad6a3dfdf71cb4c8076f86feb3dadb35167c4dc6f522a32296ffd093b"
    sha256 cellar: :any,                 arm64_sonoma:  "b91fd2b8751569ebc551ff314ed1c4add18570652f6f771f3ea7ee396e1cd876"
    sha256 cellar: :any,                 sonoma:        "189c2348eb50bd617bd426baee9d24c82027f0c84fe014de6be1d1d1a4293030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52658f4d4518c469688b333c5214393ef52853becbd85756d8a833c7c627bbe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2fd912046181d18a635eac4bf5e1b44071ac369cf2acc9f84986e347ae47353"
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

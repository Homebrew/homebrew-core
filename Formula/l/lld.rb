class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/llvm-project-21.1.6.src.tar.xz"
  sha256 "ae67086eb04bed7ca11ab880349b5f1ab6f50e1b88cda376eaf8a845b935762b"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "769ecd4d3999cd494642d16a95e02fced5cf7238ba1217dcbb650ba91e2c0a00"
    sha256 cellar: :any,                 arm64_sequoia: "e28bc291bd1f202993bc53cf84702ef24cd8f4559e12794716a77d076c78fcd2"
    sha256 cellar: :any,                 arm64_sonoma:  "fe525b5be96ffc71b24c100d699ef3c5b26d739726a052ff3d72fc1057c17d0e"
    sha256 cellar: :any,                 sonoma:        "05efcd33efbe675fd120a82d36dfa732f960653bd224e1fd433efb81ad57e173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dc7e7953d0e798beb2e9d627f15eb89ea0be56cc51a653dccd1a8185084d860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6fd257e5323e1ff604624864e6a1eac8de47e45b2371f2c3243625d7e1e1349"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"
  uses_from_macos "zlib"

  # These used to be part of LLVM.
  link_overwrite "bin/lld", "bin/ld64.lld", "bin/ld.lld", "bin/lld-link", "bin/wasm-ld"
  link_overwrite "include/lld/*", "lib/cmake/lld/*"

  def install
    system "cmake", "-S", "lld", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLD_BUILT_STANDALONE=ON",
                    "-DLLD_VENDOR=#{tap&.user}",
                    "-DLLVM_ENABLE_LTO=ON",
                    "-DLLVM_INCLUDE_TESTS=OFF",
                    "-DLLVM_USE_SYMLINKS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"bin/lld").write <<~BASH
      #!/bin/bash
      exit 1
    BASH
    chmod "+x", "bin/lld"

    (testpath/"bin").install_symlink "lld" => "ld64.lld"
    (testpath/"bin").install_symlink "lld" => "ld.lld"

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!");
        return 0;
      }
    C

    error_message = case ENV.compiler
    when /^gcc(-\d+)?$/ then "ld returned 1 exit status"
    when :clang then "linker command failed"
    else odie "unexpected compiler"
    end

    # Check that the `-fuse-ld=lld` flag actually picks up LLD from PATH.
    with_env(PATH: "#{testpath}/bin:#{ENV["PATH"]}") do
      assert_match error_message, shell_output("#{ENV.cc} -v -fuse-ld=lld test.c 2>&1", 1)
    end

    system ENV.cc, "-v", "-fuse-ld=lld", "test.c", "-o", "test"
    assert_match "hello, world!", shell_output("./test")
  end
end

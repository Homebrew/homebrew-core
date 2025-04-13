class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/llvm-project-20.1.2.src.tar.xz"
  sha256 "f0a4a240aabc9b056142d14d5478bb6d962aeac549cbd75b809f5499240a8b38"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "361ecf4b26972a6f82cac2da3ca44a1047bf3767f5cf351420aba4be0ef8fc9e"
    sha256 cellar: :any,                 arm64_sonoma:  "e6f88c1321295fa9786d77f475eaf6f38dd3eb0879f6ffc7e34482ebf47ca88a"
    sha256 cellar: :any,                 arm64_ventura: "f7eea418459e16e143128384b7f15fa56d3ebce3c6697d098d9df587ef819df2"
    sha256 cellar: :any,                 sonoma:        "25bad83b79c03b2f21cd1a1cb7f69787fa01ab3ce515aa4299dc7b5be206a057"
    sha256 cellar: :any,                 ventura:       "49425b17da457a1bb8d41052cf96d97072f3898df2571179ad24335ef5251a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7420d5df326951f81d1474d09eda555e4152fad666d914431bdb8eeb1f5c7a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6bc41cf2ce182153b2b57a1de28d9e9ce061a07ae6b58013ba2a5e59ddffdf"
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

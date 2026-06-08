class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.7/llvm-project-22.1.7.src.tar.xz"
  sha256 "5cc4a3f12bba50b6bdfb4b61bdc852117a0ff2517807c3902fc13267fb93562e"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "27313c2faf8c535fdf997a27aa9b84bdc3af4855981d4ea5e8efe6b92176ff94"
    sha256 cellar: :any, arm64_sequoia: "b5597f79d3759e0374daff35d12264a5e51639032f7ec318bfee2014867f29ef"
    sha256 cellar: :any, arm64_sonoma:  "680b25edaf59c89ce0a934d17db7c1d7d06d40938346399da45de751fead02cb"
    sha256 cellar: :any, sonoma:        "427562857dd6d2a42a8c7caf60651fa5a32cb8254f3452c856228f4ab70f0c15"
    sha256 cellar: :any, arm64_linux:   "f7e541100d50aec9da7e6a738adfcb85d575914552fb09453631d073f95668f1"
    sha256 cellar: :any, x86_64_linux:  "44a6d5f037da5e86c222cb57ca7ff607d3fa9071e78479bc88d5b15958639183"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

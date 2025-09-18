class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/llvm-project-21.1.1.src.tar.xz"
  sha256 "8863980e14484a72a9b7d2c80500e1749054d74f08f8c5102fd540a3c5ac9f8a"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f2158875f52e354ce3e7788c7f42b80bc7dbd5e6ce260430ad4f5bfbddc307c"
    sha256 cellar: :any,                 arm64_sequoia: "fcb337b2a511ff0a90b1d585242589d0499ff115aed4a6aaec28b049c6c6b0e4"
    sha256 cellar: :any,                 arm64_sonoma:  "58c533a1a43c01152dfb6a9f7009fc1ec389ec90c5f2695b8494790f50a930bd"
    sha256 cellar: :any,                 arm64_ventura: "1dc8381df53e1646db55b915d71e3e4690679286fa4da78edf8eee30370b670f"
    sha256 cellar: :any,                 sonoma:        "257c404b66b5087a07888a052ebcfe22986773d7c0f71fff484e205bcb5f12f4"
    sha256 cellar: :any,                 ventura:       "45b3eea19a9fdfaac1a201d4d6ef1e0abc393f53412210117edc9a19c775673a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ca1302b9953146309bffd2061c21b74b9cc55ad6dc67e6ed1d79593c80fd694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234d2c0f4e510d1d5ad6b44979f169c898e131675913a3ee7b323f83a29050e7"
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

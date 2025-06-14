class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/llvm-project-20.1.7.src.tar.xz"
  sha256 "cd8fd55d97ad3e360b1d5aaf98388d1f70dfffb7df36beee478be3b839ff9008"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2564e9be40a6aff7d6800e1e219400c8803b225b34839ba26364b3b0db7ba798"
    sha256 cellar: :any,                 arm64_sonoma:  "d6af607ca19c997dff1ea41b35238b4a637043b0326bb81031bafbcea22cbc4c"
    sha256 cellar: :any,                 arm64_ventura: "8c615f9517f8baa9b21dda45d91be558d4c63d258e7f62770404dcd2421cb00e"
    sha256 cellar: :any,                 sonoma:        "ab5a69c851d0f59c6d30a0fef45350e0ae30c949115fffd5b3596974808a0009"
    sha256 cellar: :any,                 ventura:       "adb569d9f86e970fcf10cc59323ecc73f7bb08a05cdb20ba5fbf3fd90fac4629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8259b10a4850df22dd34480617f68e86cc88d8df145c0d571852396643731ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d978f7fdee44c8479ed3e87491eb0bfb9d4d86f7f8f5ddf57bd0e3f98d236b"
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

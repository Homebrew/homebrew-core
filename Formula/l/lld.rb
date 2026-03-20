class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.1/llvm-project-22.1.1.src.tar.xz"
  sha256 "9c6f37f6f5f68d38f435d25f770fc48c62d92b2412205767a16dac2c942f0c95"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25b6f668a26547a7aa03aade7ea9b5d2965d349c543cde579c385ebc4dea6a3c"
    sha256 cellar: :any,                 arm64_sequoia: "a217b75bd876ebafaff03a1e473601efe04d3019ee3eabc89383dbbc6682238f"
    sha256 cellar: :any,                 arm64_sonoma:  "c8966dcd89d4a47599678ea862bb0b3bcc55f0f4f7d4f44e0f08de978f911b32"
    sha256 cellar: :any,                 sonoma:        "bab159e78800611504e555766dae90fc6a4205ccc4d27a5cea628f8d6b6e4a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9232c4426e3888b47db3d4eb317b2e2ff260735b22a90481de3ac8ea057c0276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d8409fc516750a7bc8000a748a2bf8502c75c3a141a87b45610a82903d536f"
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

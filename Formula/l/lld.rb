class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.5/llvm-project-22.1.5.src.tar.xz"
  sha256 "7972b87b705a003ce70ab55f9f0fb495d156887cba0eb296d284731139118e2c"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31815e2ee79749d1271822e8e6314df207979f081d2f31f1aa587c01aaff7b37"
    sha256 cellar: :any,                 arm64_sequoia: "d5f62dcdfefe3a047fe5982d12e9eefce265e9ef239d7d3a0b9cc4ed3ce9b4ce"
    sha256 cellar: :any,                 arm64_sonoma:  "ad8b9e085e5e9167aebbd8764900d4786ca9953466287ae0b16b7730ff235637"
    sha256 cellar: :any,                 sonoma:        "0176c8d7e1e1d81594241708c58f60c743f836dd181a8f09c90459a0d9b00cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eb0c26b1a7400a4dc0b2e96d0d51dc0b1ea6e6cf5f6215b24e71096bf0ec65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b5b0d6b4cd1449e67f852e41c0c7590bd4d8c72be7b46e80fab0febcd0e97c"
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

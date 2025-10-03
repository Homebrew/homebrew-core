class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/llvm-project-21.1.2.src.tar.xz"
  sha256 "1a417d1c8faf8d93e73fec1cbb76d393ed3218974c2283c7bac9672d3d47c54b"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef2da56898818533d5885b45a2b1fdc4b1b239082132842e5d1172e63bf7f43f"
    sha256 cellar: :any,                 arm64_sequoia: "f3ef60e29b42f261b5f916dbfc852711f80a3507fd5af1aff8724fd5926359a9"
    sha256 cellar: :any,                 arm64_sonoma:  "36e94f654516e9e4ca1cd178cd06122d899b72f10c151c47d7ac2d4d01b946a2"
    sha256 cellar: :any,                 sonoma:        "2a9371e42dc141cf404354d0ed0c506a3d76911bf88ba26e542d67791e554245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "882746ee9cdefa79a4631c1be0d77140fb7325b6afeb68570759bb2b07e5695a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827325845e62bda18b5afeba3c5a8703bf3fb0bcf6d4d0caf626f1e59a5f449b"
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

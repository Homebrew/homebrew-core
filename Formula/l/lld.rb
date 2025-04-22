class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/llvm-project-20.1.3.src.tar.xz"
  sha256 "b6183c41281ee3f23da7fda790c6d4f5877aed103d1e759763b1008bdd0e2c50"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "142f5ef84388b4e9861c135d0396aee790c5b9029cff3186af16447203125ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "a97e6948e373cbab2608ef720610214c979ed57d78e266e9c9a2061189adff38"
    sha256 cellar: :any,                 arm64_ventura: "4e6d3be69b3a5aed4b689667c5bebab024f6437e9d45529ded2b0ac34e7cd59a"
    sha256 cellar: :any,                 sonoma:        "a7ecea226cc1e7a853e07279250d8d07a782a9beadc8768ef19abda5a0bdcf28"
    sha256 cellar: :any,                 ventura:       "645a2c3e53203c29473f855416032f6f0aa358e2afccfe97591f5522e3a621d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23c8206ff14c20f0751e7d98995b406898e907d5c30be197fc254ae802cebf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56a5d30dc5903c1983ddbb56adb0f2536db027ff6cb7ccc89dddd357d705042"
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

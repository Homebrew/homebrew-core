class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/llvm-project-19.1.1.src.tar.xz"
  sha256 "d40e933e2a208ee142898f85d886423a217e991abbcd42dd8211f507c93e1266"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e0ed14b35466af459fc2b71dcc7465010184132caffc6dc5b39d742d5a3d3bb"
    sha256 cellar: :any,                 arm64_sonoma:  "4f28e71aac48f6b440347ee921244b2899ddc216b3ac9a940ca84e3a84ee2832"
    sha256 cellar: :any,                 arm64_ventura: "2e204fd2bc87eb3aea2a4723c90d9219f046768a79e83da4369c5cb537a9cd20"
    sha256 cellar: :any,                 sonoma:        "160316222f6768bc6ca9f2ed86b9a7a58680cff52d094312653904aaab52692c"
    sha256 cellar: :any,                 ventura:       "ecb25dbe74b437b1aeeb2f3e39b1d4a42d5f7797666935da68e2f346e94092e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13dea3ceabc513c60ad8b503b52d0721d8d946cee54860ba48f1840573dcad3"
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

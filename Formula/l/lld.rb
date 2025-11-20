class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/llvm-project-21.1.5.src.tar.xz"
  sha256 "1794be4bf974e99a3fe1da4b2b9b1456c02ae9479c942f365441d8d207bd650c"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fe94184a4b8d184bcaf535645d659aa07d5c8162b1a57b634a28147dba78ba6"
    sha256 cellar: :any,                 arm64_sequoia: "2091364f7cf806e1ae3bb9e7b3bbe8f4d25bf79ae8429cb9165a15ebd97a38b3"
    sha256 cellar: :any,                 arm64_sonoma:  "8abca00f58e41bc9ba07fe0c9d5c30844bd3b3bdb025f9520815d9f166bd6185"
    sha256 cellar: :any,                 sonoma:        "7b2aacf103ff9d77658451e0333b3c8ce1e32ad9814c1825b307901475cd1b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80135ba7e265f9c16dc4b5c7b59b00e36e3edf8aefb03427a57e90744f124ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd228a66567d09249c529fe1c3052fd21b76780f55d95b78380485a1fe05430"
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

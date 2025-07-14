class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/llvm-project-20.1.8.src.tar.xz"
  sha256 "6898f963c8e938981e6c4a302e83ec5beb4630147c7311183cf61069af16333d"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "940eb2261de4bcdebfec9b2e65ccabd0816de3e6268a28ff852fb8fc0e0bf2ec"
    sha256 cellar: :any,                 arm64_sonoma:  "98052466bf93f7bf508b8e75513a1c7ab25a8c61d25a070223c4ab51c219dc10"
    sha256 cellar: :any,                 arm64_ventura: "66e5f05513416b1d47a9647b4e124c2c8f0d51093d4bc8e8ad806d2f8e9f12ec"
    sha256 cellar: :any,                 sonoma:        "431d60e5b2244f976a2eea5af897ce6e0424da657b29bbb55331156ecea5f7ed"
    sha256 cellar: :any,                 ventura:       "a99444524b1084282101c1c7ca94b59b52166b864e01271ac04fa0288bad8f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b0c1adc936a043862a8545a74fe57c94a911e2d53df083c207edf3c696b58a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adca794c3722595644a6bc85c4b27b57d02e0771c054d0c59bad6c4f3029c9ac"
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

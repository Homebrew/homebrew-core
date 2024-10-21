class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/llvm-project-19.1.2.src.tar.xz"
  sha256 "3666f01fc52d8a0b0da83e107d74f208f001717824be0b80007f529453aa1e19"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5468a8e6c10d3b82434abe5e4c362342805ac42edbc077fbd5399258f2db72fa"
    sha256 cellar: :any,                 arm64_sonoma:  "5d2d703d5590adbd8996d61d2d3da0b51872c3827415ef88aa3df02ab321946d"
    sha256 cellar: :any,                 arm64_ventura: "65d1eba15e7038789763660cee27705c0d35c283f7c427138f667b4b0a251a7f"
    sha256 cellar: :any,                 sonoma:        "b3034a2cc91ab370aff823bba99ff4b23ea4d50727a6cb0d3f97bea590ade8cb"
    sha256 cellar: :any,                 ventura:       "89c04a9ebe385817266fe287f346a84c5dd257c7cee49a228fcf043965f2ec3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0f1641bd8dc7d05a3d265f86364c70ea0dba5cf4b27bc8924016fec0fe38b4"
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

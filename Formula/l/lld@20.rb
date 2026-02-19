class LldAT20 < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/llvm-project-20.1.8.src.tar.xz"
  sha256 "6898f963c8e938981e6c4a302e83ec5beb4630147c7311183cf61069af16333d"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    formula "llvm@20"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a8698904960800a3b9fb55bce40fefbb24ae841ada2b72496e3aa8af40ffe1d"
    sha256 cellar: :any,                 arm64_sequoia: "3746c0ce88a6134e98379209fc771ece464b353d48f5fe63e4d35af34350021c"
    sha256 cellar: :any,                 arm64_sonoma:  "6646125d0a82ea3710c55257051c9f9116207d89cf5c42c8a7d9f6e8f4b8fac0"
    sha256 cellar: :any,                 arm64_ventura: "433b76ece02764aa43cf95702bdfb43a04774c1b636e998af52abae1ade6937d"
    sha256 cellar: :any,                 sonoma:        "b40aa1b91f8377eeaaa9a60dc070c9302ddd8ad3e3f54023607f8d58085375da"
    sha256 cellar: :any,                 ventura:       "19566fe747f615ca035d2a28df682976900dd745b5dbb90cb38059bd2027cace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5664712e6320e1a4503fd903db1d147ae6e626fd7481a1957030efd8c9d4e9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8414f1488bc24ed303f9aa5b99945b2f922a8a66c44a3cd4335a5d038670e860"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@20"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    rpaths = [rpath]
    rpaths << Formula["llvm@20"].opt_lib.to_s if OS.linux?

    system "cmake", "-S", "lld", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
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
    ENV.prepend_path "PATH", bin
    with_env(PATH: "#{testpath}/bin:#{ENV["PATH"]}") do
      assert_match error_message, shell_output("#{ENV.cc} -v -fuse-ld=lld test.c 2>&1", 1)
    end

    system ENV.cc, "-v", "-fuse-ld=lld", "test.c", "-o", "test"
    assert_match "hello, world!", shell_output("./test")
  end
end

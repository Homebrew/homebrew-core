class LldAT19 < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/llvm-project-19.1.7.src.tar.xz"
  sha256 "82401fea7b79d0078043f7598b835284d6650a75b93e64b6f761ea7b63097501"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    formula "llvm@19"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db755b343e7fbf13bffe78d21c4e844f0aa5046f74a88a605608ad27cee6e980"
    sha256 cellar: :any,                 arm64_sequoia: "e8e71f728007bf1d4b8941fd08e8f80ba22c4828671145bd59c6358c750cb92f"
    sha256 cellar: :any,                 arm64_sonoma:  "083f908ec5c6b6d667a5c43cb737d2a826a83be781dda8856640e372ac4c0b2b"
    sha256 cellar: :any,                 arm64_ventura: "5bc9959a85616afc59418594aae9cae42e907738c2f57beac74332132c791619"
    sha256 cellar: :any,                 sonoma:        "ed20ffe6301dcc2dc7c2e7e1197cdb4d3b210fe75e9b3f525edf6fe2f29929e0"
    sha256 cellar: :any,                 ventura:       "d7395e5c60ce34541002e3be335463a81cb168f859dbcdbbaa01d985fb451c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae1ed5877dbc2837f9b02547fed455965914eb45bf6d6e40d8ffce97f0ee77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d2ef191e0b229ac246866dc5e017f9e39ce350410ce2e1141c468924314bdb"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@19"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    rpaths = [rpath]
    rpaths << Formula["llvm@19"].opt_lib.to_s if OS.linux?

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

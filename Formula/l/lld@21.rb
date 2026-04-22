class LldAT21 < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-project-21.1.8.src.tar.xz"
  sha256 "4633a23617fa31a3ea51242586ea7fb1da7140e426bd62fc164261fe036aa142"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  compatibility_version 1

  livecheck do
    formula "llvm@21"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac2b17659f0a2434c6ed399b3a0fe31c8d052f7433568020a692dfe6a213a1f4"
    sha256 cellar: :any,                 arm64_sequoia: "196025bea4256271e57d59adb230f8b99f2d153cfe027b2d3af863006f7fc08d"
    sha256 cellar: :any,                 arm64_sonoma:  "661c8726f564040c92e7711eb3cf2349bae47d2b61fb685d9660226541fe3a26"
    sha256 cellar: :any,                 sonoma:        "925d4df8fea1bf6e676095415ce8165ac5e539cd8bb1f3b143f3b480780c76b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9511e2c80b6ac5de3a96d368c432d49b0902eab978240684747222a33f825dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d32932ed2c077ba0243f2b797a0e6e3ef30a983a81a52032d42f14d68fd74e"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@21"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    rpaths = [rpath]
    rpaths << Formula["llvm@21"].opt_lib.to_s if OS.linux?

    system "cmake", "-S", "lld", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DLLD_BUILT_STANDALONE=ON",
                    "-DLLD_VENDOR=#{tap&.user}",
                    "-DLLVM_CMAKE_DIR=#{Formula["llvm@21"].opt_lib}/cmake/llvm",
                    "-DLLVM_ENABLE_LTO=ON",
                    "-DLLVM_INCLUDE_TESTS=OFF",
                    "-DLLVM_USE_SYMLINKS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/LLD 21\./, shell_output("#{bin}/wasm-ld --version"))

    (testpath/"bin/lld").write <<~SHELL
      #!/bin/bash
      exit 1
    SHELL
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

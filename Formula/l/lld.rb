class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-project-21.1.8.src.tar.xz"
  sha256 "4633a23617fa31a3ea51242586ea7fb1da7140e426bd62fc164261fe036aa142"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ee6021f18c65bd9c67f2ba0a188c2a796583ffc439e20cea0356c5f8899c78b6"
    sha256 cellar: :any,                 arm64_sequoia: "66648e121e9d933d6a3031d4c6d225040eb03354de208eedd58cf00e60040a6b"
    sha256 cellar: :any,                 arm64_sonoma:  "aa388a6affee2fa0976ab7bc01523c35de19f92c63ea33b49012a252af20e32b"
    sha256 cellar: :any,                 sonoma:        "5a96d8a685ec6867cc255309c1d65eccb9992caef2812c9750029e58f0cfd8bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce3956018f5c2d7c1da74f4017f81ca3f7772d54ba381e05f142d5631001695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34685381209fee6d3cd7dfd480aa8a0f03c5c1cb3356fc35ae5e151cea6aaa6d"
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

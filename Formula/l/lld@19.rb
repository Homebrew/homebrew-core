class LldAT19 < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/llvm-project-19.1.7.src.tar.xz"
  sha256 "82401fea7b79d0078043f7598b835284d6650a75b93e64b6f761ea7b63097501"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9ddd9901b7878ee213380fac1b20ea3623f69071bda4d78582762434604c21d6"
    sha256 cellar: :any,                 arm64_sequoia: "91bf5d8928c18a461e1b3223513526b176194a7873597eaf21298aee1fc1510a"
    sha256 cellar: :any,                 arm64_sonoma:  "58080e6765d2bb2177de344b622f7084a1d0897a6925888a561cac99f34113f5"
    sha256 cellar: :any,                 sonoma:        "363576465702b57491a005d7ba9a12aa03b147810bfd8ef3ae563d608427a00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3245e8959335acaadec464c1a92d26416c5d9a4b0bb9ea7f3d9b7e28569ed84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1a6298d29b4b92b99d00c31e753d77ad3a9f4a70b7e27efc5fc37407723405"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@19"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

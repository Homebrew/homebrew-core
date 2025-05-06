class Lld < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/llvm-project-20.1.4.src.tar.xz"
  sha256 "a95365b02536ed4aef29b325c205dd89c268cba41503ab2fc05f81418613ab63"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af338dfd47da2958de32a020142b4b8b9c0b1ea32f1216b7ef459c0ca805eb3c"
    sha256 cellar: :any,                 arm64_sonoma:  "e238933909923d9ac14dbea6b53c9eb6f6cbece4c853a252ccfde6ee69b267bb"
    sha256 cellar: :any,                 arm64_ventura: "bf18cd3f07323945386ac997a2e984d263f76e9f2a922663d49d8336153cc0b5"
    sha256 cellar: :any,                 sonoma:        "335ad97ce49f995d6e2a8ce9781b78526156b4d66e465c2c007ab5a58a65ceb7"
    sha256 cellar: :any,                 ventura:       "81a96d2e88a4d43c24ec9ba5c7cd2b2fbd82f49839f20f18116d27fd4ad9b968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7545d0d40fadeece53aa5989c150b60133d78ae877b05dda815058982f2f27dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29278d55ecfe5078dcbe0470d5bf58aa66251141750a27dadad8f00b4312739"
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

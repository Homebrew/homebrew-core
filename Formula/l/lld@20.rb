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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9be21e008e9d9d2acb2a58596e1ca5b5e507a79e5fb869779113f7df4f3f4a1e"
    sha256 cellar: :any,                 arm64_sequoia: "e0c64e6dde9be4643fce1c9ed5f0a8ddfb647f85585a83776f0c9914227cce1f"
    sha256 cellar: :any,                 arm64_sonoma:  "765b919096c9718ef2dd15103c7f9989956550dd0f4eb356dbfcda65ff96feb3"
    sha256 cellar: :any,                 sonoma:        "d4a01c675382bd918542b3a035a8731dd338c94cf1d67769fa2aa5cc84ef4a15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a0c70753e4a89e9db1ddc391bb53d7f92bf12fb05a78252df0ba3debecc5297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e555cd84ee93695977e02b993695f5f768dcd6228f3f217c0913f0a1e5c5fd5d"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@20"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

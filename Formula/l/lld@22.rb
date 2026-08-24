class LldAT22 < Formula
  desc "LLVM Project Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.8/llvm-project-22.1.8.src.tar.xz"
  sha256 "922f1817a0df7b1489272d18134ee0087a8b068828f87ac63b9861b1a9965888"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    formula "llvm@22"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ebadb3038efaddf7e25528e591638038f7a21b14158419f0d4938d124a927e9"
    sha256 cellar: :any, arm64_sequoia: "c5a61f9f79f0c52e986eae89761969afc0c8555683897102d8898d881431f2c9"
    sha256 cellar: :any, arm64_sonoma:  "3a25de5f63a66235e2498f85497614adf5f1a99a2799264400a55e3fa8381939"
    sha256 cellar: :any, sonoma:        "994ca3f898623fb2ff997dd964870a16bc99b1180f791a93815a4f93265640e1"
    sha256 cellar: :any, arm64_linux:   "c9ffa9498e8356e638fa15bee46abea473f6febe225d4382b29ef103136c8a4a"
    sha256 cellar: :any, x86_64_linux:  "709cf16903169b503ee1f13bf04282d455bdcce704e97246e00fe49d75c92664"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@22"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    assert_match version.to_s, shell_output("#{bin}/wasm-ld --version")

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

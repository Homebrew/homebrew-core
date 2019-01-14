class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_63.tar.gz"
  sha256 "2bc3e9544c89a6a6559343fe6d73bb80f01f42721fb333668a9441b0f20a0a32"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "a0e9f458477d5029bf72306f3c3fcf567583aba651bcc207637fd8327e53392e" => :mojave
    sha256 "b861ef96d5db1cb753adb84b03d034b5632ebd2e375d9a19caff2c900133dd8a" => :high_sierra
    sha256 "719fba82f58f5d48735584a12d1ee1c895a81e091a4a38b785e126f78fa5c2bb" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end

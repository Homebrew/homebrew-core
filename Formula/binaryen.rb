class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_64.tar.gz"
  sha256 "6fa24c932f0ff680f836f30d3ec66f9e456e79a0335bf02e9de43942a73887df"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "15570a6e45b2aac5f1b9a6da28edbfd2cf4b4de7c15e1dad6e9014b41bd6557e" => :mojave
    sha256 "31b764d6d610425e0f36cc97c8c4aea68daeb67ae267c3214ed100d6184a2464" => :high_sierra
    sha256 "7540a36d4e1cb1f17c46e1fe7aefed1b2623099538747577f6eae56d774dc846" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

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

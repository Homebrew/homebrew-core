class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_73.tar.gz"
  sha256 "ff2ef841026e4f65092ae225c9c22233c9e1accdace2f1dce75ed1066fc68fe6"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "ad4a98448472323715192bb04c6ed1e5ad634e81cd51c4020b6246b167615775" => :mojave
    sha256 "3b8a36778cb01d3ca37bd33e52d268fb46507127b71efdd5b095e5c8fb755240" => :high_sierra
    sha256 "84177a9fa7fc3c712624920857ee40d0b72039ade1551128cf781fe1645465d2" => :sierra
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

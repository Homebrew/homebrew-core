class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_52.tar.gz"
  sha256 "d0d4f108649e98b894187932e2c1ed629644bf1c14dbddfac4ccbc17b1d2d91f"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "6bcea07ec898763b17b41f5b9d0300d53735dc6109e430297373c339c1bb8b0e" => :mojave
    sha256 "de0029fdc89f29a1d39a68c7e2a54383180441547b0cf34f9199fd4907913705" => :high_sierra
    sha256 "2938f2ffc451e9bf72d3705a79b0810ddb2872822767ea4417a23ee8ee6c1ea4" => :sierra
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

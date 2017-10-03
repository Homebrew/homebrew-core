class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_38.tar.gz"
  sha256 "3d1dcc6d21d3972c7251990380d6dfa8ac7ac4f89d9392ed101b9fb0e7adda9a"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "a43fc8909ba5c06fab809854967c6e33a8d76c103598e64789cd7cc18612683d" => :high_sierra
    sha256 "fd7212169cd1040caa712edd1ca6512503bf2696e40ca67f7ac84849b918e4eb" => :sierra
    sha256 "67f6c59129860bfd01f517e55e6e9945b2445cbce0036addea9373f411966963" => :el_capitan
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

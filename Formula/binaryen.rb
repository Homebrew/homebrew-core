class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_83.tar.gz"
  sha256 "427506874705c7a3fda9dbd8422a6909d70da77a0c2b9c49fcf76ad6b93e80f8"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "c48be8fd07703b9f1588ae2e152267a0ed8306a25690bbd08c1b61098a3082df" => :mojave
    sha256 "04a8f926a636c0928fcfeebfb763f7b18352cabb49c941e6a12f285d15e22461" => :high_sierra
    sha256 "d2c95ee0d6b89c8207a7a93f7ffb8b5780d4ab372858e108fe7d3ef440301c5d" => :sierra
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

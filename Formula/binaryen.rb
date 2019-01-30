class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_66.tar.gz"
  sha256 "36db3a61e76896b6e2ffd63bf5b18903dffb3d28acffa4f2ea0acfa5686005d9"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "4add472ffbcbb9a8505098f3764ae745061f1059dabee83363b49fc09f00032e" => :mojave
    sha256 "145793b7b11e4c382a397b2100c27662809f8028112a3c3da27847907238d0eb" => :high_sierra
    sha256 "bb9bc4dcd2b1253bcf842f0844c655e5d3cafbed3f85bc51ccff6c8492feacea" => :sierra
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

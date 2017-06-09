class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_33.tar.gz"
  sha256 "858038e5a04ceb416fa789902151592f9eacade8e03bc84785401cfec50fb3c8"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "28fb77184057af400f636dd7b2f790df2246fe849088c2e8ac78fed334ee6407" => :sierra
    sha256 "15d06b60768fd11428b1a85f0238be5704da1de681e4f61990b859673a60f8d5" => :el_capitan
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_60.tar.gz"
  sha256 "4767358d01c7ed7a18361d5ecc2e026970f49c137e7a83fc7a8beb9eaff3eec9"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "c77adfa773c0656c09ba8810af7d7fac33da7d57545f7f4934848764ebbf8751" => :mojave
    sha256 "19b078e2dca992469df4341a8f21644bb5f6df0fd66318107cf3f0b393fa9d57" => :high_sierra
    sha256 "d739371e8a52e9c9529f5122583af04320a08f3c18f90140be8306003a919bf1" => :sierra
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

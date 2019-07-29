class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_87.tar.gz"
  sha256 "7486b03ea5474f37ed7d85becc2be615f8006ccbd4accd7dac59a584c38ea43c"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "74d707958ab60a5b125f2c9c00d75c05253b82b1d95a309521dd55c9ef788ba6" => :mojave
    sha256 "e30849dcee9356b3c5f99b163790ffebf8cb4b2a386be9bb780e6cd4c002562b" => :high_sierra
    sha256 "118a9118b9cb7fdf2aba447c31c13e61e9bd8c5e1383280fb6fa0fd2a67f44b5" => :sierra
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

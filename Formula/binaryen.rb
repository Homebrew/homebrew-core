class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_77.tar.gz"
  sha256 "7193259930905f891393e0a0b0db2b30c4dafd549e003cd58a825a630813d48b"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "982e7aaceb7d504431a40555a638e0af2addd260de28aa305761f98d199e0568" => :mojave
    sha256 "bcb61a9a7a90be6df81ed7d09dd423299a19d82d9a0c61b40501ccebef94b698" => :high_sierra
    sha256 "7b6ef73716308fe93df224e8ed0cc5c2f3eada1535cdd898af42ec31dcb4e1c1" => :sierra
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

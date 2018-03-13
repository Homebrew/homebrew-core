class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_45.tar.gz"
  sha256 "7c2e05edeba44ead365f27ce0164d35d2212577fca0964a4f695402ece6e283b"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "bf38bdad20ebad57ba63999bd2b6044fe81b3cc5b5aea83943cd15d1593435d5" => :high_sierra
    sha256 "10759f18765ef48efd18a705d5bf718dbe2661caf3c56b610fd677d4418e8c1c" => :sierra
    sha256 "edaa59c66b214dfc80145692257720fe76cc1e5051e65185a3755b7fee29193b" => :el_capitan
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

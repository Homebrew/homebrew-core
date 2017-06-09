class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_33.tar.gz"
  sha256 "858038e5a04ceb416fa789902151592f9eacade8e03bc84785401cfec50fb3c8"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "cf97939e920df902e21ad075aa9c3c2c587280cb63335e154a89c90e5fd4185b" => :sierra
    sha256 "bf5846f96131f98695e475a73a7d5c14767e2886ac3c56a609ee2b6f0e48f253" => :el_capitan
    sha256 "5e2269c335a5e6777a85ea729a597d07ce4676fe19f3aef08ec14582e0389402" => :yosemite
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

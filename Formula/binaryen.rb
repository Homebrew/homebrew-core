class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_60.tar.gz"
  sha256 "4767358d01c7ed7a18361d5ecc2e026970f49c137e7a83fc7a8beb9eaff3eec9"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "be7bcf01bac98496d184fec943357b3d529fbad20b4d9f488e16666aac6b7e3a" => :mojave
    sha256 "d544f836138623cb3fc4d69d58549c8f3db525f039ed32f2ecf6e3bbc960a2c8" => :high_sierra
    sha256 "5ea022320e308c03ed0b295a54e9dae219ece96fd02842ea457c855967d103e1" => :sierra
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

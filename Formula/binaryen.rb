class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_85.tar.gz"
  sha256 "d132257313d14ee12ee9746a7a13e81eabdf6cf489edc4215e2733e489336c28"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "cf8526152637c02365043bd9aa01b5a3f70aa89de16e581ffb46afff20e63595" => :mojave
    sha256 "a07c0a01fa5f30e69269e4abb2f3847d3f7961e190a1077060e9894b4de5d906" => :high_sierra
    sha256 "67effb148fb448ae2ace812e17848721b02ba2c39b504b68cbc61044b5c037ba" => :sierra
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

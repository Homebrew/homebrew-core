class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_35.tar.gz"
  sha256 "075ea56d457322c20cef542eba268b86caa869a9015ef52089fe452b51afa9c7"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "54a170db5805e70d6fd62c2e60e2eaaa3d5d554bf8c20cf95b41ac1dc36ce782" => :sierra
    sha256 "34f38e8f125ec50c39864069b45e49f3c3bfa5e7ca02a91de0e995aba2aefb01" => :el_capitan
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_43.tar.gz"
  sha256 "b3df0d76c237f9df446cc759420db006db77ad4deb2881aed3a59904f5087c24"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "0e16f821898a0beeae39b8e69ae1652cefd9b215167e9e10baa56840981734b4" => :high_sierra
    sha256 "f4d95143fdc44e1ffa9ec681eb2a69d92a71e98eb54ab62f3a706b6a3ca531ef" => :sierra
    sha256 "b3b7c2a29e534bb77eea53d11003b5d7d130bc35b512f98c74063b683933e564" => :el_capitan
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

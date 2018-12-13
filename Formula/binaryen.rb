class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_59.tar.gz"
  sha256 "3e1c802c13978aa270af0645c3d915df7d507fb048c34da9e9b5dbbb3959728a"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "4c957d81936142d9b1b26015d775dd0ff35eb53f75f6b9fc2dfab7501d5ad6fb" => :mojave
    sha256 "6c96d4a4470c9dd828aa190fe04e3f9fd97d679b883d1c04d0ce96565f661318" => :high_sierra
    sha256 "49a761699f2c17dd8c6008b33f9c423670715b5b4adbffec5a54e22c992043b1" => :sierra
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

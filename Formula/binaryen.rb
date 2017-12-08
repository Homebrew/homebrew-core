class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_40.tar.gz"
  sha256 "abf89db9344ed4d99a204581ac21fc7e0d15f80e6ef7334a4fdb507ba1460a63"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "fde900a304f0d544260411e9334f782005c6d6af47ea125cb4823a5b02d9bba3" => :high_sierra
    sha256 "20199174277bd6c7c3ad54e980f38e2bfc985c9bcdc0f2bc24a7c4d37d5cac6c" => :sierra
    sha256 "a6317bda019825c5b6b3e5ad4dd3a418741dc15b18ac79064c0fa3d0ac3e8268" => :el_capitan
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

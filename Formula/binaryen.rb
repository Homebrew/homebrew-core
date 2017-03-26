class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_30.tar.gz"
  sha256 "66635b931f1daa5a4f912887388ec972d3d7dde3f2852f9f5cfa51a3e6ddf9a5"

  head "https://github.com/WebAssembly/binaryen.git"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    prefix.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{prefix}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{prefix}/test/hello_world.asm.js"
  end
end

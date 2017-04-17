class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_31.tar.gz"
  sha256 "31007e95b3b207497879d171bb2c557aa5625a14087aaa57de05d5641f7fb7c9"

  head "https://github.com/WebAssembly/binaryen.git"

  depends_on "cmake" => :build

  needs :cxx11

  patch do
    url "https://github.com/WebAssembly/binaryen/commit/0f3102d13617e70b598e7d82f12684d8fa01969b.patch"
    sha256 "0182bc6310219b7993553c5155661db780c75b3c1372552bd58f364c594324ad"
  end

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

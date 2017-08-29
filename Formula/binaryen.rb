class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_37.tar.gz"
  sha256 "dcdfc95f3c1a2b2319bd525931aadd43dfb39c8e94366d3731befe81a2b4f84c"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "186881ed9555dd36459eec37df1190375256c82ec7b1c900e7745266221d8e93" => :sierra
    sha256 "e5f2a45c1c8a435edb2e7ff2a591ba7e65506e11f2bce8a17b030413f85c22ce" => :el_capitan
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

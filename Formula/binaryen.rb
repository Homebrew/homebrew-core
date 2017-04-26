class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_32.tar.gz"
  sha256 "724dfdeb0ea1130ba86dde207635a4eaf32e1acabe1e24d02e99f7d00ef59f56"

  head "https://github.com/WebAssembly/binaryen.git"

  depends_on "cmake" => :build

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

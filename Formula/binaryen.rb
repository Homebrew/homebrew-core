class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_74.tar.gz"
  sha256 "e40eaa020335cf43518e0f497735b1ad3075302753573f58e18948fd6ce5b5ed"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "e7229710a05891da73397c2a20f3f92d004a9fe0c28abd9d75c706cd66620f04" => :mojave
    sha256 "8b5325b365dcc804de7c5463b27ff00750c0a43eb92f9465711a9659f38b40bc" => :high_sierra
    sha256 "5bdbc6402990416717976e33103f719170301bad57162d47fc4398020bbcffb8" => :sierra
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_83.tar.gz"
  sha256 "427506874705c7a3fda9dbd8422a6909d70da77a0c2b9c49fcf76ad6b93e80f8"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "8013bbb770bb7f9cdb97beb70e9e589445415a9da7259b9e5e86ff68749542d9" => :mojave
    sha256 "cedcf987f49eabc61df76edfd0b4f5ab9e4d661056a2d9bd3e8687d6765be00d" => :high_sierra
    sha256 "dbc75bf712241869e3f3d51b8f797a27387815aa704d69eac288df1e1d6c88f7" => :sierra
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

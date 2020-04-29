class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_93.tar.gz"
  sha256 "a770a26dea4da4b33eee4a020f054196e9530cceeeff17b977e2bc6e4fd2dd7f"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "dd416db93657b56b97d631c946e72e0e60818997813896fb469d13e8c5d92f69" => :catalina
    sha256 "f4531b6e8a26459ae197338bed1aef10cfb367ca48a86fbbd885dca62cf29c93" => :mojave
    sha256 "c28d89a7acbd085c0b4db4c608f40fadea0619b418b73d74412666a7405dfa88" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_94.tar.gz"
  sha256 "af7d9d66cb3d8667ee8b3f92927cf94599ce4fcf308fc919853c11197f28b03d"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "016c25e72286a54427742ca4ceac4d23cd24c0e6bf6397096924dd20ca3b776b" => :catalina
    sha256 "cdea2ab19518998a3f9799a8ec28169547cc92726c5103df85926ca187cfe4b1" => :mojave
    sha256 "2fcd8ab42c28422fb1be1b83e3eed243b0b7093c4b137f7fcdf4e4ca1d3190b5" => :high_sierra
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

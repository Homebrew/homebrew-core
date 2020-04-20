class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_92.tar.gz"
  sha256 "1f7191e5ce18206ee7af9cd860e33d7f17ea5dbab7fe52194be07f95e2f75eaf"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "74849800a3a7cac003046eb367a4731b5b56a33f0de67f3aa239813b888779af" => :catalina
    sha256 "763cd723fe1f385b4dd5c74dca3390c10c0ee2650980a832b0f76829e9d24b9e" => :mojave
    sha256 "8f03486baec63ec5ff3a1a08879d1dad315dd780c50decc72f9aa479970862e1" => :high_sierra
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_55.tar.gz"
  sha256 "7c6e3cdca4c9324ffb4512edf80d20eeb0e53d64683cada75c228d3ff95e76c6"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "a8dc2ea7f8f0f16e7c3f643951f074efdda708dce72da7437c20d1422ff5d4be" => :mojave
    sha256 "26b0e1cff122b3283140d1c967a6a6b674fb42d8d7dec2db369bf568e66e37e9" => :high_sierra
    sha256 "e645eca8ace2dfdabac939bb552e69e4689ea83aaf6aa89d72db260cddae97a5" => :sierra
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

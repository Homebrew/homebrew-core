class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_55.tar.gz"
  sha256 "7c6e3cdca4c9324ffb4512edf80d20eeb0e53d64683cada75c228d3ff95e76c6"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "6bdd48e057c55259fbeec63258912a035fc96df9e8a9f42fab0bb49857d883b5" => :mojave
    sha256 "daa6e5cfcedc8b755522c5149d7fcbc10c9e187dc9cbbfbcfbfa17f64c9bc9e3" => :high_sierra
    sha256 "c5d1b26e4b2da8fd5d964e1fb9252b390196e51eb545b8a5efe6d21dbc3f172f" => :sierra
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

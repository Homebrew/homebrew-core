class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_74.tar.gz"
  sha256 "e40eaa020335cf43518e0f497735b1ad3075302753573f58e18948fd6ce5b5ed"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "480c23bb220e61fcaa00a63cf00e55e6afa56662164756e4809e1582ba86f5de" => :mojave
    sha256 "d04f408c0caab0ac34def3871cb50a5d4a659e0481566e831ca9152ea9d5f0d6" => :high_sierra
    sha256 "d2d0895e179b437dbe7ca3b4ae91da0b0aaf67ecde896dcd68e6a790d8bcf752" => :sierra
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_91.tar.gz"
  sha256 "522a30c0fd29f55d44dbc299aa768eccbda67ef134c8563085f874daa5622d7a"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "f74ec2a9fc006421a43996f12300c7dde8133cbe54770fa9058293602b9a83f3" => :catalina
    sha256 "d80e2c71eec8e27c88d6eae16b6fe48a55c5e84eed85f03226163202ddb385db" => :mojave
    sha256 "23b38465c9f893474fd27fb372e516fe2dc37d11888d49624f00dfaba398c181" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build
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

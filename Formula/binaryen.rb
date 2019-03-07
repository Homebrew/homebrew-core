class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_71.tar.gz"
  sha256 "c5430b9ce9f4086b4003cefc44bce0d621b61ed052b7dba66a3d52089635e997"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "9431c1feb38c4e41b5aa72fddf3f1f3d17b4d3763d9249c79a79a5f4989b1d33" => :mojave
    sha256 "ef2ac0ad9c5cc47e5b6a71b58adf43d71b6d7c0a87f13813615993aa0355d46e" => :high_sierra
    sha256 "fd263c45b405838a17b9ae9164e7bec3ebb6007313015242e6af73a27e0eb98f" => :sierra
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

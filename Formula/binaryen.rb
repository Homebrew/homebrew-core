class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_62.tar.gz"
  sha256 "b9f693932c813f564e830319d4169ab2d91f62bd764a21aefccbf10925bea0fd"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "951b62d345b85769f8c6b620076c9f6cbc0f4efd18870b5ee1efa4d4f398cbf3" => :mojave
    sha256 "4724f08af2fc71d7ab8d5e7d451835c0807265303a682c8e7c0349f3a4417197" => :high_sierra
    sha256 "6497795cbfe6ae62ac359a16ea0725402ae4980313411a93d5b82cb4b13360ac" => :sierra
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

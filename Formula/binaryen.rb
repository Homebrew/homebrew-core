class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_96.tar.gz"
  sha256 "fe140191607c76f02bd0f1cc641715cefcb48e723409418c2a39a50905a4514c"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "c0aa5c18994609484ed60a92c56e7cd82ffbecca4b864e1bcd7c828e10f17f10" => :catalina
    sha256 "bfdb98d0a9ba0b8e3464899e74068cf23259022076f1c0bfcd3f8bb9344ed76b" => :mojave
    sha256 "a29af20848ac6e84be7c3ac5bad3c716e920cdd6389dfb3e427df4f3b78b03e4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on macos: :el_capitan # needs thread-local storage

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

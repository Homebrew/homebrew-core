class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_45.tar.gz"
  sha256 "7c2e05edeba44ead365f27ce0164d35d2212577fca0964a4f695402ece6e283b"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "46a11f33fd8c4ab6cac74b4bf97277148badd07c77ebfd1f0c5adebd597a16de" => :high_sierra
    sha256 "2e7ca7ab2aa5c05cff50125c0f9bcca5100f38557895c09b87a2274d4eedec37" => :sierra
    sha256 "3837313e2d56eba5626c9e99d5d54eba0ec117fdc02293aac16906033cbd71dc" => :el_capitan
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

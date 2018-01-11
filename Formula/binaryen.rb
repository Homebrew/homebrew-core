class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_41.tar.gz"
  sha256 "0df53401c8cd77c796e7dbff35d409412261b18b11407fd6c5861a07570b134e"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "bfb396ca5a16dd7562a945daf51b9d7bfb063514b3149a156191a5c76c53f718" => :high_sierra
    sha256 "226aad7f6641eed9f3792e33dc325802b092ad0a44952159704be651a2207179" => :sierra
    sha256 "03e8b4ecc1b5afddef5db88fe0522d8017f6f579cbaf171493de8b51ea00c56a" => :el_capitan
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

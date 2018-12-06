class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_58.tar.gz"
  sha256 "faab2ee97a4adc2607ae058bc880a5c9b99fb613c9b8397c68adefe82436812b"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "ad099af96492164bf37d316941355b6497c8c5f206ccbbc8815244c2a607e174" => :mojave
    sha256 "124d8ed49af3a982845d818f132cf743e15bb3d1d5ac781d22af00a3614415e4" => :high_sierra
    sha256 "1a7c3c4c7dc10707cdff8a05e28b019f76a96882f737ff50d77f67a0f7bb3e59" => :sierra
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

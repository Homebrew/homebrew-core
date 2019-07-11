class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_86.tar.gz"
  sha256 "8b19e522df617c3d239188ee4ac362ca11cef7956b75679a1804ce8fdb508a65"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "63d155e873047c10446b5192a0adc8b2328f5223e4efdb44bdc51e76a1f1aa3f" => :mojave
    sha256 "0886639a414c9f60c074f1a5295fcb5ab0bd4f032041664c13ed14942130f467" => :high_sierra
    sha256 "40402d8393e275ce69d350bd06e0e3d3b1849eef35dd6ef080d30e7309ff1597" => :sierra
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

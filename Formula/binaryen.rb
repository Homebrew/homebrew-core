class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_52.tar.gz"
  sha256 "d0d4f108649e98b894187932e2c1ed629644bf1c14dbddfac4ccbc17b1d2d91f"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "0290a0cc23369ee0c100e72b57a31e0ae982433deec1b7088b79d917d987f5ff" => :mojave
    sha256 "b47da6ca77a7d84fede943f98a3605ce48c980623d0650d8df7d400c40c2f2dd" => :high_sierra
    sha256 "0f8a79f92b1f073bb176996fe1fd41d23885118ffe81a9e0c9a9ca3bb52723c9" => :sierra
    sha256 "3b31a7503ff228c86de61932cf6c897a3e4b3b4755b91cf3364a88118b102e8e" => :el_capitan
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

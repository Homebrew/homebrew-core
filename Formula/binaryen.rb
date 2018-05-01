class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_47.tar.gz"
  sha256 "596804438bc2b1ed21c8158c8e61cc1781beb4aee7c61f3126df02647cff1f09"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "f6a91d62394f7c2949259168832a0b4db8ace7974f2bb3fb288ef6c95c902b77" => :high_sierra
    sha256 "61dac3952af1e00ed86c78f85d84d6ad400baf6f3349ebf58fb667e149fe592a" => :sierra
    sha256 "bd434cd5c3915801b207dc66250a6a7db48b95534e112f124725c46c6bbcfd00" => :el_capitan
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_49.tar.gz"
  sha256 "3c88ee2b8ae318d2435b070bd48dd52a938bd390d627639f5b4b5a58e1d3746f"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "50495eca9c4242dfcd6768ca675636768d494b7790c320f84682eec4a9abbe1c" => :high_sierra
    sha256 "f5ae8c11328ebd11a40a2f1f72159bea369c7a2f2f17b59b15490c7433f81d2c" => :sierra
    sha256 "fb009085885cc50d2c39a734b13e79c2025e6a455a8895b924e44646bed28f89" => :el_capitan
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

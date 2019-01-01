class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_62.tar.gz"
  sha256 "b9f693932c813f564e830319d4169ab2d91f62bd764a21aefccbf10925bea0fd"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "31083e310d7ec4e1773efefe587088a01ebd6e54bf48fbcd14a3738407bc2dec" => :mojave
    sha256 "8a87b2ce233e32371d2795f436b3cc3b9321e89cba0a9c45bb1ff156a760d1c0" => :high_sierra
    sha256 "ae4406dd7c0e0c7e6889ab462b01a33b8e85563aa33ddc7d7d067a8a0e6f6eb6" => :sierra
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

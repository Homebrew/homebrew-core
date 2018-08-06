class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_49.tar.gz"
  sha256 "3c88ee2b8ae318d2435b070bd48dd52a938bd390d627639f5b4b5a58e1d3746f"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "613ee118e58103b57cef3a258ad3f2308bc8a0e55288a623b4900d373389db08" => :high_sierra
    sha256 "20adf28a9782e769f8f507bff0f22691833edfab994235fc15118126fd5127cd" => :sierra
    sha256 "f4696db76ee64ddf23dba0dd9c8e8c2e76000fc1416a7633a4b54994de47d773" => :el_capitan
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

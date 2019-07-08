class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_85.tar.gz"
  sha256 "d132257313d14ee12ee9746a7a13e81eabdf6cf489edc4215e2733e489336c28"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "eb10ffd6a02198e7bd99a6ccafe5b943029312f22871b1addccbddcd8413e64a" => :mojave
    sha256 "d3fef5f97e503bef2e4a3f3ab5a687b24233a7a5db1f391f870821e05b5f4e61" => :high_sierra
    sha256 "399c342eb258bc5d089747e882880c2b5ba9a6840b8b4e1e0c3435084538f936" => :sierra
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

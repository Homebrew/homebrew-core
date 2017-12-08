class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_40.tar.gz"
  sha256 "abf89db9344ed4d99a204581ac21fc7e0d15f80e6ef7334a4fdb507ba1460a63"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "0f6357c92d2abaeba850145201feaeb85dbc5509a20195dca0b5c55dbffc7e36" => :high_sierra
    sha256 "534bbd1913afb40065c2dea6cdb1e2f2fa02b42fe4d8e114d3afbac09950d548" => :sierra
    sha256 "88093915c285ef93f46ff47d001b0c8a24aff4eb951da74059fb4726fde06603" => :el_capitan
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

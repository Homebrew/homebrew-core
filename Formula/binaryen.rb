class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_88.tar.gz"
  sha256 "32129819939596951eac63b2bad94606237cddccfc7c702e53c39c83841bb928"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "1147378c72da918d11c940637bace748a792ba641c8a81552f50893b0aee45e0" => :mojave
    sha256 "6b074bcc391a1c4829a07e6d2df123701f7d103a170dcddb9a77c0de3552c8d2" => :high_sierra
    sha256 "a24e836c6b31cecc29a758e3088f7081a83ca74e195a12988ace64b01ddf9dc0" => :sierra
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

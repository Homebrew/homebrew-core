class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_68.tar.gz"
  sha256 "5efc90705246c7684672b24d54ae177a661b64650877649dbf5afa3eea34d729"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "6fd6d1921836b5494558e28fcf4f389025e9998081a33a4f5b49104262d061ec" => :mojave
    sha256 "1e77f75cbc073f2dc3b600a4db4ab71f9db5857308b0a84f3c54b10463a8888d" => :high_sierra
    sha256 "eabf6de1a10eacc777f0e2b402de372457b99eba12ea853153c03ea3f9a3d8c0" => :sierra
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

class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_96.tar.gz"
  sha256 "fe140191607c76f02bd0f1cc641715cefcb48e723409418c2a39a50905a4514c"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "7c6905bb823bc074c511c37825cc188a468c89e12cbfc5a67ca7c68b601265c2" => :catalina
    sha256 "7d009fdeb08206556958d213a5607cf31132d1be24eab48bc51ec92254c1723d" => :mojave
    sha256 "b330e0ccadaa5b8496163af5e7bf67d890240aeda3cd42bbed64d1e7992bb1d2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on macos: :el_capitan # needs thread-local storage

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

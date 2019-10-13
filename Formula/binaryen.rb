class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_89.tar.gz"
  sha256 "e8b35e751cc9b90ce4c4a9d309595ee9c3afac2964fd0c4cc06c12ec43f6d55e"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "6389d5a1ea8e005f4c4bc7201c97eafe92532578c8ff8ffc11e2a304fdc91d83" => :catalina
    sha256 "ae2ec301300e14f81b8e25bf769e54aae7487a2758729bce24134444d63590d5" => :mojave
    sha256 "972d54b6dd59ee9ba94eccb42b499e6c1c076edb4c487c9804933000e15c9f31" => :high_sierra
    sha256 "e554c3403521e69dd691ad7af18cdf6120fcb3c06db0bedfa44c26228292c131" => :sierra
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

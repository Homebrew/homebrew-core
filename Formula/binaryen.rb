class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_97.tar.gz"
  sha256 "a1bb8a62851706892faabd4f2aa3c6f7f00462512abd1a6923c746e51290b265"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "29926bf82ad2f8389f3da27992c05c26814a0f5497612d4605160d30b89cf08c" => :catalina
    sha256 "5183aa663b9043908110604965f532b2f73a8a28dc43f512dcf9cb260172f951" => :mojave
    sha256 "344d469769a1bc1ad0c33fdc27edeb2c75b49bafb748c902665d31ef298e012d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on macos: :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O.wast", "-o", "1.wast"
  end
end

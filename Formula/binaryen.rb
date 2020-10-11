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
    sha256 "70c4d803444623b98349c7c034dfa8c5eca69b1052d6a88cd7440b0897d1d531" => :catalina
    sha256 "53a7faa235834bfaf3413d68dd6f2159601e557cec56ca1b96eaf3667911ceb6" => :mojave
    sha256 "847b719342b38437ce6ccc2fb8c8f8e7dcd6760e3c82f5ed52765a2d62198ad5" => :high_sierra
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

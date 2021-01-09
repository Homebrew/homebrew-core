class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_99.tar.gz"
  sha256 "66ac4430367f2096466703b81749db836d8f4766e542b042d64e78b601372cf7"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "5d5ac79ec3aabebd8e62433c84bd0d61b0f4ee44d56e4c4f47475276a6428bd8" => :big_sur
    sha256 "6bd35ef9c849c2b2302486ee45fa6c05302fa27df0c12c97f4b6014e18b8f320" => :arm64_big_sur
    sha256 "260a8deac0c78a9fead982cf6d05fd818330bc4e28cdc73ecd5de6952ded6e8b" => :catalina
    sha256 "7a68230a62307fbd61638803e942e4d556f99b8e4d6fbbdd3dbaf6997b3b2843" => :mojave
    sha256 "4656a9b10a7db143e3619126ea1e0c169d05b06b27c7e75d5f641c86135c7b1f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

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

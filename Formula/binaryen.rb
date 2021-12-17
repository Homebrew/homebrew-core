class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_104.tar.gz"
  sha256 "a6acabb159fcc5b1d8c9506f5036dcd1e4446952b572903b256af955e959780d"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d95f63433c51b451734614567d3d1c6ab17855a6aa1dc003004fa8bfb8cdf983"
    sha256 cellar: :any,                 arm64_big_sur:  "124ba8c446249721a2ea62dfa6ea325f058b9c4550333f6f2edc4ba8aa1be569"
    sha256 cellar: :any,                 monterey:       "2e55a4f849802ed9476a42590d3ba216b86a2648bb18f618a118dc13abe66853"
    sha256 cellar: :any,                 big_sur:        "00563db446a76fcf45b6c80aa1e06b111398446608ad7d908a963bd7d1564ee8"
    sha256 cellar: :any,                 catalina:       "f78575ded7f2a516700aae31a15ceaa131155cc67464ce50cfcb803c3f8241d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40347a762a1d1262c5d3bbe8dcf73002c41ca12140ca06a6ba6461ec43c4baf3"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end

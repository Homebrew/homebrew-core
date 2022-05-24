class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_108.tar.gz"
  sha256 "7fea5013da7f98daeeb6a0a60333e8aa917bcb0b1b418ba8531fe710d09041f2"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "05ab0825261a8f802203ca2e58a7d1ddf8453466b878997233c6e12c018efa81"
    sha256 cellar: :any,                 arm64_big_sur:  "2adaa10bcb3e8acb7c0929809364e8014f49c0fb295a442d4a9fdbc5fe7b7584"
    sha256 cellar: :any,                 monterey:       "92c73aace568ae48b4ed8c2a3af8360d468cb87a7d4f8efcb7bfacb9e864a189"
    sha256 cellar: :any,                 big_sur:        "bda5f9b8a3c2ecc7372a0913f42b54800ace22d7160c002a7e448c269857b5e2"
    sha256 cellar: :any,                 catalina:       "bbafcbb6b6fc38712d399f300c29fe2711f85328a94789d0c1f58e3a33ba362b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3fbad7361b591a38c22c16bd751c48e698c7ac36a5bcc8a3b469b03f737115"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=false"
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end

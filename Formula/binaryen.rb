class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_109.tar.gz"
  sha256 "e250310db0ac480cc121c72757816346c946f6c33c788b369a742b690089856a"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af46ba9d11c1ca19483641276f8d6dd7c983fa4e4e0e27e833591034cd62a2cb"
    sha256 cellar: :any,                 arm64_big_sur:  "08765a7a1de7e5233a47c7a54abd63ec64b2f28f179d2390506d764443dc32fd"
    sha256 cellar: :any,                 monterey:       "3e8cd5e87750296858387afdac008452ce32f9efe449915b4e96c9e46f2949ee"
    sha256 cellar: :any,                 big_sur:        "c8060eff6afec83c9636a79329b67a67f5bd259e2a999b7e22408a82604a4b2c"
    sha256 cellar: :any,                 catalina:       "f2afc26acfb849e9843586e61087504736ebe5b444289e67b49bc60fff7dcbf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b1b9f7882c1048b6a61fc9736b4ac05201198a12c3aa84b836ec8371d58d54"
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

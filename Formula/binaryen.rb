class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_103.tar.gz"
  sha256 "568fb4a09a9ce4a21f62ac8596f393c2e89f39b96457d5e7c1f67db0fe74a88d"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f02eeaebc04fdf9dd37dc6c5e1bd77b84a0cf6c69c7c7212140a1622eccfb2a1"
    sha256 cellar: :any,                 arm64_big_sur:  "9a62a3f0d97c22a2e448f13e7c1460f2e2aa11eb302112bdad398e3fd58e94aa"
    sha256 cellar: :any,                 monterey:       "dee1151ed7fb6b987a7eaa9cdb68a53edf1dcf9b1a1c599b5af11e2b3f4ab473"
    sha256 cellar: :any,                 big_sur:        "176191cbdaab2ba40ebd45ba1c420cde545787bf22364ce66755aa31374993c1"
    sha256 cellar: :any,                 catalina:       "0434f120ebc68e0f2015c7dba2fc2de1945890c6ecf8fad50ae83fa9985c5168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a7d40d186b45af58fae2c229fa3fd8e50cd221f1adbf380ae7596b0b107a9c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end

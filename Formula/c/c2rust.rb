class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "cf72bd59cac5ff31553c5d1626f130167d4f72eaabcffc27630dee2a95f4707e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98a206d507f2da3996fd319e341de81c76254d98b3a5d607db5403b1cf6ac711"
    sha256 cellar: :any,                 arm64_monterey: "85ad71fbc83acf2e5c6828e71d1d8490767c825652eeffe14c8bde8daa46f57d"
    sha256 cellar: :any,                 arm64_big_sur:  "7f2009a3a0edd49c972c3466b5914439e4b13510a041c4b250729d574fa26bed"
    sha256 cellar: :any,                 ventura:        "615d64b0907a80653c3a86072fa94fe70bc9fa9918d1c7a42bc09e8902e8b724"
    sha256 cellar: :any,                 monterey:       "eec3bde1181c4dac28702aea6fdf9b8c520394a60e1db26c19af660868eb624f"
    sha256 cellar: :any,                 big_sur:        "de6199fff18618ea3e68a913387508b167cd62defe60b939184cee2cdb9819a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5740665ba6822fd9287c3ce2516b5ab95a714962ea7a738b597bde7d7297a667"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_predicate testpath/"qsort.c", :exist?
  end
end

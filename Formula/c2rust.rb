class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9ed1720672afb503db91b30cec1dedcf878841f57eaea4c7046839890990d8cd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3273e2b69c83050f500993c11f7f64fd2f93249c123bf4680b3f1321132452a2"
    sha256 cellar: :any,                 arm64_big_sur:  "a77f2a4bf5276333f97711bb7dd39bebe1bb621a8d0ddad389ccb76d7b3fef51"
    sha256 cellar: :any,                 monterey:       "5644197dcaf9d4c3ad60bb9c23f37d3ab9b9f6e9372501a0e7baaa4cc2633e43"
    sha256 cellar: :any,                 big_sur:        "d62b726bf0c9c547366eb30b56f6e779aaffded61f09e5dbbabf276daf9ca794"
    sha256 cellar: :any,                 catalina:       "5726ecc28aced3d728e39a42ca0bb63319a16680bf392d89570511177ed39fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1eb6240a68f394375a5fbaf71694279628f8299e241a6afd32f3932a3450fb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@14"

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

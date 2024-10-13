class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "912c28e5e289d1a9ef1e0f6c89db97eba19eda58625ca8bdc5b513fdb3c19ba4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9868ff52ddf26a449db237b4ecc72dafd9137c672c86744c3f480f0b69e607a"
    sha256 cellar: :any,                 arm64_sonoma:  "1c74fbca870f39ad8c8920fcbf153200a04484e333230b9ad0dba80894757936"
    sha256 cellar: :any,                 arm64_ventura: "6903c7d307a32e0405e691e71e0915910c7acc537ab8f662b5d178530809e7f0"
    sha256 cellar: :any,                 sonoma:        "35789caa2462fabfe9fe63d63613e6afd4035173bd2c0f30a048c51ef0ee3e95"
    sha256 cellar: :any,                 ventura:       "520a8db5a7bb6e0ab226a70c24b68d7dd4c11e3af22d8c1c6fa5779f8b09e011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f1ba002a700369c7118df22f22a61e25ee5d1d093f7173211de77e356e89ce"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@18"

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

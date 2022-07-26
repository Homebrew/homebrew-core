class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9ed1720672afb503db91b30cec1dedcf878841f57eaea4c7046839890990d8cd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8f8d44f8ce1e9b5bc5ec7b078e917aad8881132d8bf2d631914f980df6a95fca"
    sha256 cellar: :any,                 arm64_big_sur:  "2767b652b7de529eac674d54714b6c25e575f1386d9157921a7da5b2155d0005"
    sha256 cellar: :any,                 monterey:       "70383d07df935d669f7b68758d6686ea4540f45f8b61dccc6d8ae38df55d28ac"
    sha256 cellar: :any,                 big_sur:        "969cdca2dd9f981d867c89543a510f7656401dd4e179e0df2160364754c50d89"
    sha256 cellar: :any,                 catalina:       "fd0e2212d09e70edb3c85014989dceb5d8acb0f22826124464b3bfacc03fcc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d945e4f1cc87d37c001c959934c8aa9ece15bb8d87173afdc215a372f64deb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

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

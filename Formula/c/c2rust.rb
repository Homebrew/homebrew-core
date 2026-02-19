class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a8fa6a88a5f40f35b1e63c086e981e8e03e0b887b769ddcd07ba46b0304c931b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c102b8523d87342d212c0537be581176bf6fd92fcb5aef0ab1f06fc29db8dd8c"
    sha256 cellar: :any,                 arm64_sequoia: "35604832b9de5a334662d6574f24863458bf5614ab3ca481d9bd0a31b5c511cd"
    sha256 cellar: :any,                 arm64_sonoma:  "67b16a49a8febd56916efe46371ea4b60307f6fe13196924246d47bd748c7c8b"
    sha256 cellar: :any,                 sonoma:        "303de80f782220e9efe2b493cc284e8734ba67ad0e5dd39fea8856af48bce5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437dc4ee245412452288566d60cd9fed3c472819758da0f23745072ea70c2098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7998d5dd1b663ac7114a8132ab3e9f39a555cee30be1350f2bf27b157beafdd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_path_exists testpath/"qsort.c"
  end
end

class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.42.3.tar.gz"
  sha256 "2dfd1686f33e902ab907441090db12b83da87b77c687c19c72ff31287fc582dc"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f0214d6b70b2596fbf6023ce8a17c0a9ddc34339851c54a314425597d9fe934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21702b462975b40f510ea27b152d5a2863caed9bc9f68c564094dc318d59ad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f395af13a9c7ed2e1e17ec416905246b1475a59b5704726fa0aad07c06dbf74"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ce1c1d9359e8bf9f9cb7ff99e2e0dad989b7c3b14df7b85a716c8c3ee2d828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e3e40993259d7f92ae6847f3b2d24fcc8c765a9787c5a8fb8bcd60eaad6abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e7e9f8e04c33df5d8c422041280664a5cd638d547c561bc5f203b1676ac6f3"
  end

  depends_on "rust" => :build

  def install
    # Currently uses nightly rust features. Allow our stable rust to compile
    # these unstable features to avoid needing a rustup-downloaded nightly.
    # See https://rustc-dev-guide.rust-lang.org/building/bootstrapping/what-bootstrapping-does.html#complications-of-bootstrapping
    # Remove when fixed: https://github.com/facebook/pyrefly/issues/374
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Set JEMALLOC configuration for ARM builds
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args(path: "pyrefly")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end

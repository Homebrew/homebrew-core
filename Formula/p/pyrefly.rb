class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.50.1.tar.gz"
  sha256 "7a5976c83fc9e0020d5e7aeb52a477dbf1812ad343524cd41a3a3154403fbfca"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d576ea8bc516d60bf25403cfefbff1e1cc8497b68e07bfe3748adf8ae47eff99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3650aee6424c41ae058f0957b9216670e82d8abf35d80bbebb8ee8583801a6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5358e90a13b351b2ce111ce721055f3f24418cb4ec034f1df94569c0385cf08c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59f99b2a2607cc7d223d24bc48a61c968f1c68e1d2a920b190e1d2e011d98267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "622717ed9ae7bf5c27e996f44ad2aef16a43574f1240060389ae052c6b3e2eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb891f7c8b34f3a5fc3763f8a436e4948ec277a04fc232635180d0d2dffa5aa"
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

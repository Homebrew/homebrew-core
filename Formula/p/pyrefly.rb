class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.33.1.tar.gz"
  sha256 "aa0dfbcb22b91c3910d5298a6889c4c4e2594bbe1234178949d140cdb341eb12"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "233729d516b4dd09431e15940c8c1c7d37577b701d4bc466098d49b0a7e78320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de470d67faa0f45c0242123cf703d5193177f23bef0274813f56a8e46f4a22ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cefd551bc94c0c9f330a3fb24762e40852444341265a32134bbfe6f5a6075bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f70c965905c6690dded5ffe8fff2f4c1711cd2389bd294df087b9fee180bbf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "129de0bab74269b320728563b024dfb5f542e97a89d448b4d6becb5e36d0fc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad187b4e94c8297bf09c343b8d4ccb0b3bed5e2bed67df59de7f9b3620496e2"
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

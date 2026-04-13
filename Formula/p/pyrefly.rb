class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.60.2.tar.gz"
  sha256 "7e97ee8276800d689069e44051dff5e89e970b0af44b0c824afe7e05d63cac20"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b38e618bcae61ffca582eda7a9ef82a87d8a3a5f42b619dfb2ec0dac3448b09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee4261a06517d53893938ffa1530d196f155e71ec8ae10cd302dc4565253444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0db868a234ffa5b8debc1822d27cf6cefa22c6ebb057940674e654a867b06fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7d2a4362e7b3c47ea97155e95050ea41a44666474fc0f0aeb84c7db585e352c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3cb4e1b2bb9f671ca4f73a0126cfda1cb0c42f13bb7b4ed4a8ed2b9ed203203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f4ca5b2dc538299d57b0ea91dc04bb0f882584e5a2a5d321c267e0c854c64a"
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

class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.53.0.tar.gz"
  sha256 "acaa6c2d908c049287c4cebcaff66c96f953892ce191ec6545809a716541bd51"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc15568420031882d17424804b1aac1c4a1d48aa1dd6ca2f18936fb1f44e6023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5d1e390098abbbc4e30ec5c6198bd1dac9bfea3615e1c653f50453635fba12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0969f7e35a7ce075f7c57073291eefc3b8c1f07c4baaf91b3c91f30ea06c4898"
    sha256 cellar: :any_skip_relocation, sonoma:        "463a5609b4c4d1eae6dc866a4f2cf27ca1ba8695b108e511896cf9f6a6258c16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1458cf5e4edf789c90c9489ff80e7a9e28a8b8af1582a9a9878ee31a20d38c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809ff80e0b5c6be2230e7f8ad8efe6937077c76af008150cdcdb16c62aebc41b"
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

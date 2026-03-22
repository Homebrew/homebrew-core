class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.57.1.tar.gz"
  sha256 "8e03327b65498a8fe43e51436a9142b73c765e7376f5fb727a01b13d87c45700"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "308b66e1fe6ce101022e7616f63dd6855f0333108d516ee8d68094cc38eae138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c954aad5bc6d85916848ecb13c1d96514c29e781d027de342ed254a9aeac4a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f437cfe1828dbfc36ee08aed6abc2a9187626838f8d78d00c8bbbab8363dd9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d4a7405efec433521f5aa321807caa5b156f5d2f5aa9557e9389bada5e683f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f9c98b5b09b427f1ed480feb454e327c73e2af9eef47c513de2bcbb31c2162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec17ddb5a9f5dd8d964cebc123ccd7ffcb492bb1d9d6f3adcd6d78c3a2548c2d"
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

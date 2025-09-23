class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.34.0.tar.gz"
  sha256 "3869577fbd9ef3f6adfb8ced6d4b5f66017cd8e08e78bc356a9859ce811a9219"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f24b063197401c21a244903767ac707dcf079b2a72f38011f6333f8bd4f68d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e65c178fa77ddde9e9de0700483291068aaea249ace2c4c57d061a7a10314a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ff16465d2729bf738d8dad56a5116c681e12709ee69f065edc74d41c137e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d15a0632a69c01ac7944e23082ae927cff8a76e4d4cba7b32f4c44aa214d2139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4974326d5c0ef356e69b5fec548e0b407500f183b5aa101d985d198d6688087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79e2ea307af95f3395e193309c606761db5ccac4815a66854f9075d560920cb6"
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

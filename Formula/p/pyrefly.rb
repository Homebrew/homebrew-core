class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.48.2.tar.gz"
  sha256 "b2fca996c7de15247fc9465ac80c8c95a51a4412075b98d05065b7d391dca5fe"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb8b5371c05b19550ed7cd7e6bf0fdd573064419aa72e5364f578f3824811c34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a1a0e9a56dc8cc46842b11a05b1653889cafdbeacc1f6821232114106480e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e418d4dc9599f40d2123e4713055ef330233d844f06662b780cf39c2af57a089"
    sha256 cellar: :any_skip_relocation, sonoma:        "9540c6538949f08febfab093bd40a8521add4f49dc086d2b2e7f2ebc5f1c8013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "054c5d62e85174f7590da61ac45c123549f2f4e8e07bec9b1511bb4f15d562b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2c85658e1fc7768266c7e5ce164d3a0ac5c3602c3fd3b854fd7fc9702c9b497"
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

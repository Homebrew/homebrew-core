class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.62.0.tar.gz"
  sha256 "30f9811f19bc5472970debf8260bc2f478ffa842327d64c36de6388ca2436850"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f1d6d9f46e91f58aaf704978191ef226fa2d43c72192e6f60b50a9355a9567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8370fd113c42354301da6323103e4fa76a7c70c9e945b8261f62b8e27ce404b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "458cb2357b3c2397a6b49c423219c22906b31ccc4be3057e23437089673b1bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "349438f61a63b0c999c8da704034698919059b9b526de68235b599841fd3832d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94a0f0a8f41d63feccda7b0f3ab44786be47ebcd6dcdca2af332995c28eb32b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feea0f598b1ff424bdcc2f26b8826c48abc9d8d75f37edb15d3531abd4506175"
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

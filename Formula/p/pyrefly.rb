class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.64.1.tar.gz"
  sha256 "f9f3c9dfb2d47f968628f0c1bf128e83352ecb3137215ba84953edd4db95d877"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62a7e5f7b6e5c999cf2eb70c07806ef1fddc530d5e471ce6d22d1bcce32edb8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d62c03eebb3266f73483b97610d0d9b44db9824dde68955a7b701384dc4baab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed3ff29993aefd55cef5f55cefeabbe99052751df7f18b97480642ea6677adbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71ec78996c258ae3144375ee41834ce2c354773be73a4403a736b5b320912db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e6da885313f460990935253f7815fd63c6a2775b18493ed8f5d04ad33ec03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43efe6048743b99c2494118a9771bbbc54f0a4e9ee8b4568dea4540294806433"
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
    system bin/"pyrefly", "init"
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end

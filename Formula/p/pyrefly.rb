class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.1.1.tar.gz"
  sha256 "b0de811112349a53422532ab393bdd52c7a3a97720c5bc498c1a314e6b2406bd"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a3fd0dd487c8599754e6d07e764d6cb1bf5167292fd5836638f4a078b809183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe1a90eb2ddd7e22a5a8ddd7edd11841452a5eaf33351b483353c09924860be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14ca8584f6e32f89492e9f4009754929ac6be60503b88dbf2e591c6fbb61a71"
    sha256 cellar: :any_skip_relocation, sonoma:        "20471df134d9a93961b91cd4affdf8aa72b09ff7783387ce575acfe79d517359"
    sha256 cellar: :any,                 arm64_linux:   "e89058f4cdd788b9416238304e1e785caab56a2ae714cdc2773d94e28e219625"
    sha256 cellar: :any,                 x86_64_linux:  "e5786a3883adadf1aada470b38731cdcaab70a3d99c20d7a2a518ebaf7071c01"
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

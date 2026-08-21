class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.2.0.tar.gz"
  sha256 "39c3d391da0aa85eb7d0149fc57e860495f50e431f4911547f21906a35ab33bd"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd151c3c14cd310a23f8eb567240ab934f465ea42dbd8439dc0cacb5b102b64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10cf754a65ef0787a04e5416d9b5024545638b7932c382a33dfecce966453a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db870658132b95e8b263ecb802832791722a6779b74a55a1b92595816fe743d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d720e97f378cba554b757727ea10bc1d71ce15d6f0c9865dbe2b1add4c4fda"
    sha256 cellar: :any,                 arm64_linux:   "b8a4cea6234cfe5ba939bfbf8f654e8a2cf9ab37a6c8a17f9a40746b8d25eac3"
    sha256 cellar: :any,                 x86_64_linux:  "930f2e0f89aa97e834dd4c6979f510428a199bdabeebb41dc4c6fb954b3fea64"
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

class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.0.0.tar.gz"
  sha256 "a92476d5922edaf511020f8edaffaed91afeef64e0040f51a43151efa715136a"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4337a1785db9b7b54ccd865a4fb853a0729d5e368d4c470bb68721bdccd0b525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45497197611fc40202695e8170c05fdbf818f4cabb667c0bf085c83c06b383b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b05049c2a145c30edaf2694c55b66922d63b92c046e320ddfb36280938425fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bdaf9be0b71d5f9671078e984e5e7abc2fd3923ee7fcf1d7ddc647ed72ed64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21f9de777ec8dcf7f652c246cdcf51ac6ea5830baf463311270806f979aee66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5fa5e4d8e3b93264b13e7643b52225f845a52e31de149d3a06d19da02445f8"
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

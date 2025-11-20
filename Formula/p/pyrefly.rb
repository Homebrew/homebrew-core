class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.42.2.tar.gz"
  sha256 "4815733da564d6e5fd68cc6bb3ee516a0ad30329fca64b08b2081308577bbcbc"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c71761003d8534c93a312750161c7286d5a5dc42e6b0ed44bf1a8c5c0bc0e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d72a8e06cfda28b053660d5f8ce003f4c899eb6dd76587366b5ba3c392f396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38840df192132f8cedea80156bee0aa87ac8c1e1cbca28c0eeb5f35b70cd38cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd72ea68ce07e7af1388cb3c454f0e5d489abbdefbaf1afd9586d8b1c4cf4f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce129a2280ff8c48684274a85eb6506bf6af2f520b220ed5b04e89e0f272da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cdee9ce47d74cefde6c797c3818a223b37d916b32021601a3b88bc981c4b3f5"
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

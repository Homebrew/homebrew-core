class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.33.0.tar.gz"
  sha256 "614a7c38d208659649ade69a69032f5b6fce477f091550718491e957a8b244e2"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2d817c78cc3f7a01f56c44043be066ce89ba974d92af2fd351b8ab953f7005d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81fbeba29b9ec7e9c66607a17cc34a954cd0e5e592f5d9c8ba39cd06f1c39a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b9be34e3e9d4b81d71d17bdb4719c07ce0358e839351d8eef58066a81af4abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db47f1aae9c7b4285ee5a645ab8ca67023c1d8860bd002c9a4c9d450d6a3642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e3b47dac330b9a2ff1f0bf8f8325a18c74c3e037024e2eaa856a271f1d3658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f274abf6b4914873244d3ca7cf989c2cbd7e49e13c6f7415e259affcd24fd0ea"
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

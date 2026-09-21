class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.3.1.tar.gz"
  sha256 "00777ca516a4bd6740c2f5b2c70a5ead3349bb565e5f86ba8ae59810b5ea3f45"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8114d22ab33328333b216cfabe9bdc40b7ab24f56ea1afbc8cfee6c3f90ce0f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f49bcb78ca6d0c9ea4e2ca2e76b194435727cba6fd5d04d1a85adda46006726c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74faa4a53f2c104575875b13af7a0dc5c13e719de90f6b32da2b33ea8159adbb"
    sha256 cellar: :any,                 arm64_linux:       "dec38253d65642540a7228375dd40f251fed568353292caab56abc523f7fe6e5"
    sha256 cellar: :any,                 x86_64_linux:      "d62e9dec44d7596db6474e24ddb0c16152fe31f7a630026a251a848414964dc0"
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

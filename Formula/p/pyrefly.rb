class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.48.1.tar.gz"
  sha256 "872784a8a94947a97c790e5a52f1d51e9b42de2d5ab78e49f49d6479510d20a7"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7e731e510fbf241d47dd3a4bd0e9773fdd5b0e40b22c7a721d2838542dadaf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21a3dbdbcbde96235f2c17175453ef1610bce5f532dfd052b80a9b543571b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc4f72f5004eaef42d9adc4670f68a1f47221f54d1ef707ea9f711b1c05ea0bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a893e3c169f76ee16fdaf755b5aed45afded7023ddf589fc1552c0bf284312b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "019d46c08680c8584b8f2c0765c9f7fe9d4a8e99235c3d9f3fce645de30c7bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cff7c1af6825fe1e09662ddc25fdd56e5c697309908defccb917a725b22f43"
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

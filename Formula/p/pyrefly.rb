class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.35.0.tar.gz"
  sha256 "98ee5d961826b2081da96c71c5908656c4f4baa0e8739254ce32ead142e94d29"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaebb315551eb7b83fdc39930f96936753cd57f50190eec4d6383c4c9b7c37d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6b54492a75a0ebec9b2da139279389608f1ab64c0f1d96283e06e74c2b735d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b4f4687306e5b9033d2a7be25e725bd3d84a568cf722494e703f6e5abf4b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "86395e33058fdaaeea0379515d371750f3cedc54357fe13f4964c7fbf912ade4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8ef8b964517142a5c397ef0fe4efd6db157f20ce83af999d1216b9e89caec48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd76b130de05412054332cab36ab6f7c2425b18412fdaea04d1cab5de289395d"
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

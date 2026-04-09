class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.60.0.tar.gz"
  sha256 "b5a9ea757a59e816af8f653d1fea57e89b0ef0082a9b594177cab96014e44476"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "389b86ba65a10fc2df1456a93513a0e6471c90f33f68bb639fc4bbf29f75137c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f41af0183f399a67c98710ac795fbd37945d6a503e9a6a52ba754850ba7f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f98c1f1fa30310a3ff28ce3015da87a8cafa796c047d1949767c27bc7cdf0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "956b12b032b3d23d3618a8d5c78ff6e409260d75045bac2f0363ae1b51417a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b38cf7ac0f1acb1e94935653efd9c96ec8cd2be3ec345f638d8dc5e8628f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff490993a2b3d32b250a098ad637382ebfe0c55d14ee9ded256ba4dd5692335"
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

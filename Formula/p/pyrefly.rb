class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.49.0.tar.gz"
  sha256 "5086cf44ef5759878f58bbd6055935fc3660cccd8db6ab700d241bf405687ddd"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba1fa7707eef1b0715638dc610b940048e9d4346382bc51cb8fb002cd6ebc22d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6cfc35c356abd1c69010c7cf2c5d60a4ec97c27150c3338d11fc4a8fe1eab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a5164f7f7e02d458e514b65680c8b9a4ac3b8e7f90741124c5724f84efec089"
    sha256 cellar: :any_skip_relocation, sonoma:        "93d45e986b0a62a28a9127a02de8fd00dd354b57bb537b076d4c72b5d9df5178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14594919e3bb8ed59afc69a457f07f8059946e4ad4d9559b889809974082f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675df17d2ee10a7df89c242e748a8052e122b636aebd2e58097c232ec4349bd7"
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

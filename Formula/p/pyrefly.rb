class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.5.0.tar.gz"
  sha256 "87b240e0224a3050f03ff708efbd528ef52419078e2838eb41b63a897ea734e6"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb712d43facb0047eae466d403919377a8b5a8b05c3b2370d67fc9a26aae0843"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e390270efc702cf14b59af95a29b492bff4224f6ad79584fb08b110fcf8f3bc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ac2c0d1d06117d6a5a0926626dd22a493d41f5f0fe0aa84370b2fb1ba97b03e"
    sha256 cellar: :any,                 arm64_linux:       "a5df154720b5f33c9fe6e1021ac95e80b79eff90976bca1191c684fd8f494787"
    sha256 cellar: :any,                 x86_64_linux:      "9634106c7337105a278a7954bff4533339577687c15e7edd58475b6ae53ff431"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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

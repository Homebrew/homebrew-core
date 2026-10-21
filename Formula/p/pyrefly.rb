class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.4.0.tar.gz"
  sha256 "491cef3a7daf3028233ce9a1f22b36bce52670f29848559f998c4fd6cf2b4b61"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4906d94429658019aa7a050e949ff4026cfdcd0a085597cfab9a38c9b27bd0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7baa1fcbf5d8fe6b2c6c70d5d0032b10a19e850ee7b376956bd68eb0f7a4aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a481ec24a75214e9cd66002d9bb6fb9a136597745e7e164899b97e87fe92bea"
    sha256 cellar: :any,                 arm64_linux:       "3ad803b395546b38969c2742e2e2f0e5246558e364248b1429a5f7ade321b44f"
    sha256 cellar: :any,                 x86_64_linux:      "ad86785e47fb43f65737d2afafa6f7ed265231786ef5ba16e2c7541948ad51b7"
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

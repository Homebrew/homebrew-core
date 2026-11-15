class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/1.4.1.tar.gz"
  sha256 "9ee9147892727ff0a28d5cfc18f13440f8d267fa018213bf5b97beff242db3e6"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f98d668933ff56a59f4693b8152e127e8362ab0a3333d152d137a5a8c9acecc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ecd2f47dba2763233315511ce0234b7c70a00d928e6431977ffc52bb0f34c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87a3ea230bf3f476a6bf1bc212694e60d4a0f52d0d88556940029348a356f1b4"
    sha256 cellar: :any,                 arm64_linux:       "c28a48fd8eb7a4e2b29e39dc3c8d660f4bcbbd7685b4a8561ef56f6d620cc40d"
    sha256 cellar: :any,                 x86_64_linux:      "095997ea7d2c57df5076b75856d292018bcbb4a55af77693187cf3c2923bb935"
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

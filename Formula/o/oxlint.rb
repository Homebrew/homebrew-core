class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.94.0.tar.gz"
  sha256 "b1db39aa7bbd784855c0633c0f402239bd3b6423ddbe27417a41180a1ab5a41e"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04416414178def27a841411ae48d33370bd9e5c97a1e3b9c8af366e99d10d8f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "328d48a748e844772353f14e70751b3793ab265ff2392666bf706f14bf76b4cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcc9927d1be97b258e6007b6256c55bc22ae95f6b9beb88e01afb78a02832b4b"
    sha256 cellar: :any,                 arm64_linux:       "96a3418be1058446264881163c1e98b9e343c4498e5302f7347851e560ef00fa"
    sha256 cellar: :any,                 x86_64_linux:      "ed85c9cf5360f68bba7e59cb9294335cdd2bbb079165220757a43ab735466963"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end

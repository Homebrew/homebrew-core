class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.80.0.tar.gz"
  sha256 "56f5ac5c3a8829956c82a29dcc78a00b456d703b1bf1c0a8cc7153303ce80005"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fda2cd05520e7a87375a9a238b2b3443a691a27bd07cca237248e9efa531f3f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b8df56aba19732a8490230cdc2b69dd4c76d3b5c799961f6ab9d1e30619270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de5690c6466ca0230723c3f6da545f198d36c7935ce7e7fc87e40115d6ba36d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88a7b8b86492a6ae0d78f89e0fba1a037c096dc37fdf541a5777f1566268974"
    sha256 cellar: :any,                 arm64_linux:   "6896273c9e99285fd54446a2de2a72605ea40efe56b9112a27e2befb17268866"
    sha256 cellar: :any,                 x86_64_linux:  "93833faa52930bb32bef84c1bec07d0ca8bad05712d587936c6d24365d83f5d6"
  end

  depends_on "rust" => :build

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

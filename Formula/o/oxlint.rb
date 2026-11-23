class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.95.0.tar.gz"
  sha256 "471ffde9613a5c2e8263423ad702c4001c0aedcf98a679cdf9b7b1f136a33ee8"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "92c0a15c9ed2d7617be298f6345f6b2ebe95425704f18e7cad18d802697c62cf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1c9869e6a66510bc640826ca820d3c8b5b42271a8d71268af3f5899a37841c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "017d71f4346a806addb58b9be1608f596f4f2de7eafc97134060cdb59c08ef9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1873e67824bba12fc056908b7827d4fe2a531772c540808eea71421ba774e748"
    sha256 cellar: :any,                 arm64_linux:       "0101947e7ce5b1c83297097e24734392ec3ac6fed68b8ca8e215af2a4e0bfb0f"
    sha256 cellar: :any,                 x86_64_linux:      "75753f3000c134a61175b0543f7bec3ca1a76cb377abffb7f92fac58ad5836d7"
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

class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "6e6da68d8f630973394d7f1319779edb1f1f3e19590940291c947a3601892155"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c771f1b1948880a980e81f1d4955ce17a9b95236218b35dac7b7ee37f87f160"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a51cd30fe233ad50c22aa13f39b769b3bf95cc21ee86d7123c4c51c5f407bb47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9fb4abf96d6d89d3e11c8d4114d9c2671bc9296c55c6c56f2fd0b9b474ad2e6"
    sha256 cellar: :any,                 arm64_linux:       "f5ceb6ccb61f89767fd6267d72aff81bdde6898bfbaddf24f6d2feb427c1200a"
    sha256 cellar: :any,                 x86_64_linux:      "8d319885df65eaa364f01467e95970d3b7c97b73a947b0f6700c3d921d7156e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/obscura-cli", features: "render")
  end

  test do
    output = shell_output(
      "#{bin}/obscura fetch 'data:text/html,<title>Homebrew Test</title>' --eval 'document.title'",
    )
    assert_equal "Homebrew Test\n", output

    assert_equal "rgb(255, 0, 0)\n", shell_output(
      %Q(#{bin}/obscura fetch 'data:text/html,<style>p{color:red}</style><p>x' \
      --eval 'getComputedStyle(document.querySelector("p")).color'),
    )

    # obscura blocks fetches to loopback/private addresses by default (SSRF protection)
    blocked = shell_output("#{bin}/obscura fetch http://127.0.0.1:1/ 2>&1", 1)
    assert_match "private/internal IP address", blocked
  end
end

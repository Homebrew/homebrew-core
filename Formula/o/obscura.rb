class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "6c448e4c1deac7e057a146f53005c825ded428fb642379911a04f5dda8eaca4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7755c52b382d974705946a037900d19ac9b9d2fb7f97c1e2ae09334820b3a57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58b5c6879785d8105318d7b45453b3fe8ebe479282e77d41a669aea077b133e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1828b0c3a42d92cd2a00416c4403315a0d760675a9a76adca0d0a1c8c4ba768e"
    sha256 cellar: :any,                 arm64_linux:       "7ed51d5d77cdfac047abe2b3bc075c15d4593a461c33befc85774daf261fd066"
    sha256 cellar: :any,                 x86_64_linux:      "bf455bb95c5837a0c5b9e09a627825a60b274d79f111188925e44f429aa37d6a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/obscura-cli")
  end

  test do
    output = shell_output(
      "#{bin}/obscura fetch 'data:text/html,<title>Homebrew Test</title>' --eval 'document.title'",
    )
    assert_equal "Homebrew Test\n", output

    # obscura blocks fetches to loopback/private addresses by default (SSRF protection)
    blocked = shell_output("#{bin}/obscura fetch http://127.0.0.1:1/ 2>&1", 1)
    assert_match "private/internal IP address", blocked
  end
end

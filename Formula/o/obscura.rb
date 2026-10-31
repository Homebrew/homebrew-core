class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "809fbe7636a755e426257bb1c0fbbd390316f78026bfc468f4d483db7b31c07c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7a6361e5c9af1a4ffd5def8751382ff3ae1e6d0c4a5d4a851d9aa6c5fadc041"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f15c8051fdecd3f8d1814f862cd5020946c02eb66e88d4f07f7a6a342e264b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7255e7f2bbe6b0f85ca13b54b614f982e952051ced0beeba70b62945880801c1"
    sha256 cellar: :any,                 arm64_linux:       "2d24ddd55a843d0999028405446c80410ebfc4c1529773f64af33f79e88167eb"
    sha256 cellar: :any,                 x86_64_linux:      "e2f2e61ee406cd28710f8c0559c64c00daf790b7dcd31942d9b527712ae5541b"
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

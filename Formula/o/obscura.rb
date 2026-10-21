class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "af287fa7658270a68ad6f1220197eb55035614a91b14295117da78e55494958a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc74fa36af69116f69f76355a859ae443e91e8318e5a312c67f2aae21412d899"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5194dfb186815761c1cabeb78385f7a74f8aa3a3d016d199ea2e28657eed119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be54c5f7f125aa3e22b3b70ae8006f4a1186c62d65cd76b3ff74d3987686cf7c"
    sha256 cellar: :any,                 arm64_linux:       "29367528a991a78daa0601b7d1bbefc5b4bed05908377f53dcad8c08528446fa"
    sha256 cellar: :any,                 x86_64_linux:      "455533e00843bbefbd3082e654f16778fd4a6be8d0d3e9f7786f1c056b6e2514"
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

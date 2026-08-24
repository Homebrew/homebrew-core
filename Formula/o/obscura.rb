class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "8572780dca68d49090bd46ee124a9195fdec75b18ee96b782f8da09490bfe0d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30307b41b6a25558cb4cf74fca573bea58765c26de84ac85075f802f85a81b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee9e65676e3820ccb88dcc270f9853040d1c31c8fdd6b37f66bc4ac8c8f0de3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e80c640da7e376085a1b9ddad79c78dfc783beaa7c2eb9baab6df8c418e9e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "937f8a73cc76ca6acd67b5f56e39f45063843eb829aaa8a2187a9575652329e0"
    sha256 cellar: :any,                 arm64_linux:   "5b11b9454428e3c5d249c83b9ee9865231a90ebc30d43482d4dcb160258b0bd4"
    sha256 cellar: :any,                 x86_64_linux:  "add772006a3cf80b6ab7537e82cb1bfd2bbfc5d451b5e8ab2c25b7379de03d75"
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

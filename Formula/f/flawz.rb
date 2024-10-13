class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https://github.com/orhun/flawz"
  url "https://github.com/orhun/flawz/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "743b5b687b702ed24245111b988680b546fef479855309d87057ce6ac8ff465b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/flawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "693340e4af8411af31923c490337f7ebc80f6b69458e1b97959f3ebbffa6f5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b19ab4fbb6411b2a2c870e0f6503e908c1002e3ba1226e88326c05f5dcdad84b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0ffb604c728350b02f048cf73a8244d3e8f22c0dd0b7f3877967fa604f5aed8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b1de55cdc164a2867875556b275fbd1da985f8fbd1b68b49d858b1c9e9c023"
    sha256 cellar: :any_skip_relocation, sonoma:         "f376b5b28925674a8a5a4040b5b6412ad583980f8f10d979c81b34fc4427930f"
    sha256 cellar: :any_skip_relocation, ventura:        "bfee18af52a59af4fc11f6ffca201a358a4321f381db0c6c35dff8cf9815665f"
    sha256 cellar: :any_skip_relocation, monterey:       "2897e6cffcb9d31f2987c967876b138038b1ed94c0b1bcf537af2804936c9f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a195329fff395c89e34b535c7ee89a09e4f8133cde2b96013b175ba2e0c6dc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"flawz --version")

    require "pty"
    PTY.spawn(bin/"flawz", "--url", "https://nvd.nist.gov/feeds/json/cve/1.1") do |r, _w, _pid|
      assert_match "Syncing CVE Data", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end

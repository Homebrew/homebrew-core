class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat.git",
      tag:      "v0.2.4",
      revision: "f80010584f9bedd7d0e0a0100814e28e887f1cbc"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "167ac04a16c970791e495eab93df2700416578776ac86b6fe3ece7b50fa3a80c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50bb8bab2bd28c8c33cf87da5b342dc52c8d61dcb6b49d169fb42cd7d4a29178"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e7148ac2ed663ebac316b1ddc731b7446d793ef736c8de90eaa24fda24c575d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e7fbb4cfc90539740e362f83946d1ae9af85656c298176010e0d785244be8dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f967b674999f0dd7bef48cd2f99bc19b2195911e6ce5bd4bb9e9e85761a0e24b"
    sha256 cellar: :any,                 x86_64_linux:      "3018a61e3bd4fe2230ad363d71407c41f6ec87983e643f5b592e924b6e48f85f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goat --version")

    output = shell_output("#{bin}/goat get at://atproto.com/app.bsky.actor.profile/self")
    assert_match "Social networking technology created by Bluesky.", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end

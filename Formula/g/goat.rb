class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "4bb6694de3b5621de3b6cc309671ebe3366cc68eea77b58b7118954cb974f863"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b190ad4aa9f6002d12cf00af639ad7fc2b777dda32478b25d84c56a837413db6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fc79262d579829354d55bf5d06f7d02f7acbf96365935a6caf754f6cbd8638a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "435c285fb7c6ee406b3f0b29658a27b33adf3b489f60fc588067a51f9d93192d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8531deb521e20289d91ebe9f1b254cf85cb940774cb702c9d188114f72a7a635"
    sha256 cellar: :any,                 x86_64_linux:      "328034cb0e169e2274d4ac7f2117aa4b7a88d21737ea7ab42a1a7802cc4079ba"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goat --version")

    output = shell_output("#{bin}/goat get at://atproto.com/app.bsky.actor.profile/self")
    assert_match "Social networking technology created by Bluesky.", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end

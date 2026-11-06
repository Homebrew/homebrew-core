class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "4bb6694de3b5621de3b6cc309671ebe3366cc68eea77b58b7118954cb974f863"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18aa2049f6bf18f08090be930b2ef85e34a7ad6194f20bbf82ead4740c9dfd52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ca88907a3367f8ba15d9e89916b877d27eea4d09578409de4370fed70350556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0854ef4c7f848c4c648b15b46425f4dea1f065434c232ea9b65cc96ce53038ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b47a40f4ea71c8fe5f91d7a852055843eb9e20d7e99c815b64e7efddee2e449"
    sha256 cellar: :any,                 x86_64_linux:      "fed456e8a1a1a564b4bb433291f1f674ac5079d3b25ede932eb939e69ecb4fcd"
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

class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "259ade7fab8301c65a88d3a4add23b1a286bc3ff0b7bc233c5e45cb03679c498"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    manifest_sha256 "ae26d71b71296ca3daea3b6aeee97e3eb9daf1d08e3c99c2e3d85b6e2f0f348c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c98f57d4e5e1ef95a19303388a413812369761ae3acd3a5d7164434fd4099601"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66dfe302510989896df82a1ffd870b607d0507e695ee316d61084744356b7f4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa662514e0ae27db7ddb40023f5373e749b99a7099574a191bdc2218ab170f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d97dd4e61464845cf893c26d5ddff30836e75332bbe1f0f229b06a8b2e0d21ad"
    sha256 cellar: :any,                 x86_64_linux:      "05dba1076840a95eb66565985cda35b25314763597749bb153249935ba7c8e1f"
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
    assert_match "\"$type\": \"app.bsky.actor.profile\"", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end

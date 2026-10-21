class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "3ab36603983d516cc0cb91c384e97554fa22a124bedfc91cb06c4fb7a5c774d5"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "396c33a61b82772ae21d6105859a5b237ae197d28ca41e206e42ae92267fb3c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec90050e840302dd549da69241777834b890b51ce41c3945031784c8b7ae0a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10193aefe3b494dce1dad78d52a0dbb4a2b3e6ffffe07c502b4e424aab2179b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "826eb31ba70bbb230130872fd5a396918828542377ed8b50fe8c7ef93be61246"
    sha256 cellar: :any,                 x86_64_linux:      "40d08fb1081542d90b3768352a8808c1678b331ace96be04cc15134af92a5724"
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

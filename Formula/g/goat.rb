class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat.git",
      tag:      "v0.2.2",
      revision: "e0d07777202ff31584cdba5bff2e17464a1a47d4"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e39513caf89997046ba0ca71465786d825f508c802664f319c62930fd3adaabe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902ffbc1806398617828ed3701e2c9752fa8da42348f1aaa472df5d996c38c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c210e93877c06a76749d39186ed861d196de8f1a30844c8068012937607782f"
    sha256 cellar: :any_skip_relocation, sonoma:        "70bc4af94d8a6abf480f57d28cc87ff10dac480e8f2d949082462fd44f75d453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05df26aa557900203f1bfff7f5838fc5668b6bbcee84dd8cd83139df9776772e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b72ea449365c79b6a117fc9da331d936418896af06d2827a43d3adeb157456c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goat --version")

    output = shell_output("#{bin}/goat get at://atproto.com/app.bsky.actor.profile/self")
    assert_match "Social networking technology created by Bluesky.", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end

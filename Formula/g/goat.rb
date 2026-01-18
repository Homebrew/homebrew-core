class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat.git",
      tag:      "v0.2.1",
      revision: "7de8078885ebd35a5b74e8b83c5c61dfd2ef9617"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "385af0e081775d9e727f1f595cf26acbe5d44b39749bf82e46ace505bff60f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4adcc869d0e40384f0fcb49043e465c8c6b808f6ae6c3864c9adf0ca34f7641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "868c7aef0b913faf78ecd99f39934df372c669897e6e3952c76855fa83f9b09c"
    sha256 cellar: :any_skip_relocation, sonoma:        "da10c34316399378f03891559cbef39786c405e91c527c5aba2707cd677e743a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5078ae31f5750b4f077086eb5f25b853ddf885e2da10d111a9da5d545cc5e066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bcecd461f5faadd1a253a0a9c3347b238c2db514cbd899e297ffe9288f2ab50"
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

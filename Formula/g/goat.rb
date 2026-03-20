class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat.git",
      tag:      "v0.2.3",
      revision: "d064a46ac03be902dca493b6b2ce1659e8619c3a"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbc22f94fbc87509b125760ce494928398a3d285425d9695fef3ea1122df53fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2d349dd06ec0f121a4688759f56e42f87cc25636c642a6d867b55e7530ccc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81cedaa97db152d867b68ac38c800affcc6733e109f3c6b0ddfdd78e8405a470"
    sha256 cellar: :any_skip_relocation, sonoma:        "aca4313303e102764b77b3f43b3a3648261221c1b572e19a2ed978cc501b643c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d8aa8a1407b7669bd07fd27e17ec3720513fdd94e10ea05ef9fd4700a07105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3d597186e4b7accd5867e0394442bdffab0ee0e62d587ef1e7a38489a94cdfd"
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

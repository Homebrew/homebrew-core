class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5f4c200625f0a1eb7a1bdb5578693fa30fbc935eb66608c9bb6d7aef90566bd8"
  license "MIT"
  head "https://github.com/simeji/jid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5188209f088f09f2212750095f0aff0878077d85f4736a76d6e84458445518a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5188209f088f09f2212750095f0aff0878077d85f4736a76d6e84458445518a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5188209f088f09f2212750095f0aff0878077d85f4736a76d6e84458445518a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8015d25ec616f1674727d781b41a94ae4e310df451bea89d048120b9bc3fb02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a61a61f15dbb2d884158b1553e69ac49b134fed0d0875b7bfe6163cc92cfe9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22bb14394912bb0c2746fe8a757c8ec36a27a16fc21cfad5d9ebbb0a746ade6e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/jid/jid.go"
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end

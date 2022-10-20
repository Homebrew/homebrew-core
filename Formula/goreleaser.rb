class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.12.3",
      revision: "e27e6a9e8c66ec5d2bbcafb1c047068bcf250269"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0622973f5b60159ee8a6946137f7e0360a2a41c1223797cd1a5fb950d4b5d5c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a336fcd4a025f006360f3e85c70e92db8eb6bd32004d0c5fc300e3461d07ea1b"
    sha256 cellar: :any_skip_relocation, monterey:       "77b8cc4c8d358467b7cb7401956f420631137a5773eb2cbaf1490f6a3c9567f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9d344ffb820f3e70e0f567d9555d7a9353fcfb600dec8470d7f882c96c10834"
    sha256 cellar: :any_skip_relocation, catalina:       "e5db0ebba6bfa2437ca4aabe03be0d76442ebd43a91b4baf36d1af77e3d2ea0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecfb2741b3994741d19cc39c6c2a18eaf51c183d602d53f2db1da54ff9f17e60"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

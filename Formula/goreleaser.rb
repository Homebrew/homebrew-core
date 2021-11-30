class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.1.0",
      revision: "af4a8642bddb171914ee932bfb5768f102c3516f"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50957e4a291c1cedb0469cc5a872e40b6a91de05aa30376667a5853d1835c6cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51532c991b15668eaa6e50c706d237971f1ca19358052e986f68f004ef86acb3"
    sha256 cellar: :any_skip_relocation, monterey:       "c7609360d2e2fdea9ae7073727bc0c2ce6620c14587dca061647f03a668f17e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0559b0d927d30d8dd7bab3953937a828ca15c66392e60828360cd8d3c1dc94b1"
    sha256 cellar: :any_skip_relocation, catalina:       "b1df587fefb7c4f7c5846f8db41a76501e9690dc3e143afb6523afa17b83951a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a68770b047cf4d0ac9c7e68316f789e29e7c15c39918ab3f3922ffdd0a51be"
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
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

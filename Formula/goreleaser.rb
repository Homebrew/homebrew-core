class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.6.3",
      revision: "42258cf4733a9f42b17ad1b47fb7e6e2a10369c0"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de438784a064f114550d5e70ea5e1dd896d1b713cd4d77c5b8f20aef4509ec86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b694aa93f7e4f56cc3127283b68ccc3e7b54e8fbf81af4958c723eec1d0d4ec"
    sha256 cellar: :any_skip_relocation, monterey:       "f9f964f9ce696048e92aaca2528c21352965695d2b215e0df09f73e1efc0575a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c95ed1d85ca54bfa99c02d42dced08e8a4b16070d20711b3e6756ad291e54967"
    sha256 cellar: :any_skip_relocation, catalina:       "2887752329387ac27b2bf621c5dc918af5a015c324b1635722ac303624034a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f188b533144666fac52ae53b4cbf6f8617d7805b7cc7dedbb24a28f57f0337"
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

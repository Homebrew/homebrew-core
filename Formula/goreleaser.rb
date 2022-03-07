class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.6.1",
      revision: "788a4394e11ed77e0efc48b9beedbaebb41bd7a3"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062d4d41618f71d5a564ee737858e9ebb0bb47a949e7751e6097d0ba830bb2b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da707d7c1b9a8ef0600d47cd639d35adfc26e49ce5c7137cc95a4a639cb7ad68"
    sha256 cellar: :any_skip_relocation, monterey:       "af3f2fa371fb618e185c96071cd59d99a1f41e90ac6c868fd3bf86f2ca30fcdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "88cb7fd87ca40b183da6a8f5bc98ddcb3b3380bef04872283e6fdcfe02af3f97"
    sha256 cellar: :any_skip_relocation, catalina:       "b2d2f82d07c2fb819a0aba831ac7adfbeaba1b57ca6e1f0f769c75666b84afc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c8ef7a9c785841efa3fc6f6d21f3abdeafdb13e2897d561bc357c0487bbe9e"
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

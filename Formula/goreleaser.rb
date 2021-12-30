class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.2.3",
      revision: "89ece5595a924dc6d3b3f2f1a741e420a209757b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8496e8578d1c9d893a83a683807230e37793701fe595263c4361d1e1efdfc911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eccef4861a9828385254c1626a5fe81e7a15139d21c512190a831c937b16c57"
    sha256 cellar: :any_skip_relocation, monterey:       "96a9a8c772e6b287515ec43f07ac1e8d8bcbe2edef24ad0d4c99f69645ae8339"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b5a46a60c75af45b46f036db9a32ceda5332af1f1502b9ef0ecb438627abee0"
    sha256 cellar: :any_skip_relocation, catalina:       "32487393b97e059982b982fd0c10b01c172a9d61d212fab542e20c4d51b6822b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6959b7afa2cc027fa570bb7d445810c747590173f777ff454ed6ce02cdf61ce0"
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

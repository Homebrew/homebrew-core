class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.178.0",
      revision: "68ff8e996f6df76fe1cb2dfbd2a06e362c7ec5e5"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9308f09c2994c339e2b0ffc329326a196c24805aca734a43b63b52beae15c36c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ba8570bdfcec6efa879cb723113eeed831661abe6c926b355b55066ad8d40de"
    sha256 cellar: :any_skip_relocation, catalina:      "1222094014e4c301f5ceb3aec15b2fe6fe1fc65b3ff7a2604e95f7b871155136"
    sha256 cellar: :any_skip_relocation, mojave:        "74cc4f4c3bf57e52e6fc5225d3c08d682eb3677851d29ed1448aede18693f88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b72bebdc11537d0d5ddee499f15e4a4083bbfe96921bf2fe0fc966666976cdb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ].join(" ")

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

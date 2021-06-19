class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.170.0",
      revision: "e4373447181af89a10217ffb2134a64e610eec8d"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "afebda65db5f6cf28361397d9ba56408c17499b9bfc5d86473e3e2d62cec0baa"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2d40e2a1b53427b105a95256e1d3c9a25af4d0486897502dbc77703b3d0f737"
    sha256 cellar: :any_skip_relocation, catalina:      "d79dc2fd56dcddeabf908996e5e386dd19b093bb45e406a373472cf143c7a31a"
    sha256 cellar: :any_skip_relocation, mojave:        "48df2119bb0f01bdb678422a6d58844200d38394a4b24bb40a39614325b48991"
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

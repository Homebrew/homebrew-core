class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.9.1",
      revision: "e8307e88345f36a84a3a1bb5c24d947ad68cce40"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32ef8f70b8a37828b970904d3f8ffdb7c0f86a34b6e299308d344c4ceb27434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a89365ecfc0d6684c37e21a2cbac2708947211777e4adf801f598cf0f8fe79e"
    sha256 cellar: :any_skip_relocation, monterey:       "fb76d4b830500b6c85fb86ca6c97c669393eb8ad04fe0495929299a55fc70864"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cadc5e41a9b714527f2165dc8b2e1acd19313e295f01541de89a6eb064ec807"
    sha256 cellar: :any_skip_relocation, catalina:       "4d0547daa6101a265f460107d051442fe53b0a4bb52a2fa57d1932d721b09775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23832d3341657bf59d5306dd3ac7fdcfce410f86933005025030ec97bd8781f3"
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

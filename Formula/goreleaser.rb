class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.162.0",
      revision: "8306b946d3ee38a25d30c46bcaa7b12071a7256e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6820efe0f661622ab12dacd2f33e1d238258776da468ce4714cc172db6debe9"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc3d5c2d12082238992cd6cd11de0abef6386c6fe5ec1f35d779a7e22a2f8e05"
    sha256 cellar: :any_skip_relocation, catalina:      "b324a8baccfa0cef4257fb62ee066bfc1dcda4b34a8d3c1206b2b1a1bf999419"
    sha256 cellar: :any_skip_relocation, mojave:        "afd4f5feb9399cc2697e6fbb3ab9407cf2b072b5ecdb5c9cd5f12bd776a5c0b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

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

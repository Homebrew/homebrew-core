class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.162.1",
      revision: "e4e242f573aa6337a6d7ac70c0ce29121e9214e7"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5122bd00ee5b6ab6296b58967efa6dcf23e0ec88598df0a87bb9151d2d81e2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3eac4756c50f48618af7c91b4a13f67901271721163ce2858dbe9cc55706e4e1"
    sha256 cellar: :any_skip_relocation, catalina:      "1a390375511e7e00ef9167933a8391bf4f40718d6c10b337b51f302faf297966"
    sha256 cellar: :any_skip_relocation, mojave:        "dbc2425111ca54ba8b929195b6a6d703b3b2d0d75ff0f572a210b3141dde3362"
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

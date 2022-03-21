class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.7.0",
      revision: "7671dab291483b2733e871abff379d07e74dfc6c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22fea6d24bd9c9da0173cfd2a41bebb07dc61e456b99e7e1d8ff373f4064cdcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bb1f53ee108cf3c63e690293618fdfca7df9f4bde80e063d6e08e3abcb47e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "9cb81351d7913caff5d50250afc02927ed0e3b7b8e2b99eafb033d53e1adac3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d7e8e8945d5f193a9e69f7a896d6d11c2294e0dc394c050a859735f846aab0f"
    sha256 cellar: :any_skip_relocation, catalina:       "8d6425bcf30313b2697f8715b981ce89d212202e2ae70516bd3c2636570f6671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a632bcc6ee92a6502c70a3725964caff6f29b3def4320e874ee74af82bde51"
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

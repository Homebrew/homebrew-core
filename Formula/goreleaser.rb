class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.3.0",
      revision: "3d2042cbf4d3b08a8395f0a4099e4bd31520dc24"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8602dbd02d6d16f2597d2343feebb99428dd95ee3c0277d2f74e4273e12ea6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88d9cc1436de4d187b7ca7f7b353332955709b300c21286d52e07e3bab8bcb4c"
    sha256 cellar: :any_skip_relocation, monterey:       "8acb07a2885c761ee2128c21f4f2eb8c14d9a3e308311f609068c231f75d5e09"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0517c43b9eea08ffa8cd102a3b758cc81cd1640e418875963ae986081b520d5"
    sha256 cellar: :any_skip_relocation, catalina:       "dec85890b45b837be18430ed78b0202e8e35faaf3d8b85ee331caeded38a5e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5dae7df87ca622a439b2f7421785a53f1e18003f1e71da79aac0b5203b678d7"
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

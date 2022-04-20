class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.8.3",
      revision: "63436392db6ac0557513535fc3ee4223a44810ed"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57f616b9e4781bdb5df1cfe88990dd6b4322f803a04c4373f548c8be0f441a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442c188a78e838b57a705d08152103b44b95a20f69142af9dcd5c28c4074cc35"
    sha256 cellar: :any_skip_relocation, monterey:       "a2ce1991fca5a1cb68594e3959ae5f4e828a288dc4ffb2bf936e4872f4e7079d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6108cf095bbf5104f42b0dbb63c6793e45a1b30549251777983e3ae76b5f81a6"
    sha256 cellar: :any_skip_relocation, catalina:       "008de76f5431177d8be30fc8b5e903e876a58b897ae2af4a3e2ce18def177617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2363891591cc740a02be7695e421519a6b79a134fb52220d543e2e8517a83d9c"
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

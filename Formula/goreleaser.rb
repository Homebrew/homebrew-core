class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.180.3",
      revision: "c7580bf49f1df01d0f0c9be4ef85c5161a165978"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb91338fd4022d935f3d82921ac564b746cfe8daaf6c685ad137fc4321ced24a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6a996ef1c4362a82656d9b8542f0fb52124c6f4044125ca189455584c59daea"
    sha256 cellar: :any_skip_relocation, catalina:      "e3c7eeffbbd8d718366b3feac39e762097e5375810d3f243bbf6d98f672dd0c3"
    sha256 cellar: :any_skip_relocation, mojave:        "245a223befca5dbac7fd2431b191df8a04b9cdba15e15e05b3c17fee2541cd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e62ebfb0a0b956d9705f1dfebd819e426bdaeba20f238d08815db49f06fea62d"
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

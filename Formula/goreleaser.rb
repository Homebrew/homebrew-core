class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.166.1",
      revision: "046c60d20dc37ea23daa23eff328cc8b15ac7c67"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f46ccdab615110dbb941b0a5dedb650b5a415eee60ddee1dd9370611de48364b"
    sha256 cellar: :any_skip_relocation, big_sur:       "209409216940d39fd9bbbeda6665a20c5640488ff304d129a3e5855c406f7994"
    sha256 cellar: :any_skip_relocation, catalina:      "ad73f4d9c13ac922223d62bb8cff229bf03d3011e42f44372550d83bd23780f8"
    sha256 cellar: :any_skip_relocation, mojave:        "f785a8cb3621ac460eac0ad495cf55a767507fc115f0bb62b2b67478bb1cc1b3"
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

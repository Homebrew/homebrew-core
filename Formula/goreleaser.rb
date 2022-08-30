class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.11.1",
      revision: "c81221016704e3f2dff72b60903f7f5f72c6f640"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd16f2a05539d857d5889631cea6a606c86f9155e4b2b71b28f13472e4aea80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65d4525873a5ba559ac22c107c3b8aec40a7a9f0c9d34e49a6906fefe76cae35"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ed3fdb6910832059a1fd64602e43e03ecadc37c1b4717f0ba1255ca4643c8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "80ee5709a3d925cf2815c6d6989d049b544ae74ec07cf14dfb4712e2a14c1c99"
    sha256 cellar: :any_skip_relocation, catalina:       "ce2f80a795d59ea5ae3f9036551486d1e2e35363aad4b7954b6cf9bf2fbd181d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92e120dc085e1baacf1bc4477161b18e154d75e068dd3d7bca4a2ed161e8bb6"
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

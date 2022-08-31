class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.11.2",
      revision: "e31f7806dc0073159cc12dce7605073259105a67"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28cc477c831f95d7ffe61ab8aab0a151295ba8aa866ca6634d5e389aa4444800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "984b292e4c692b4acbbcc39bd35c56d034faa2279add407b86a0427f6b9b6c76"
    sha256 cellar: :any_skip_relocation, monterey:       "b6adfc1b2550642dbd9ac932fd616b4801bfb3989b6a138ec740f1f6ecf28969"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f5f0be5bfa5eae7695f822e51e87f41abe8584a82ea74a4ae4993cfe5b69b02"
    sha256 cellar: :any_skip_relocation, catalina:       "2b1f8fa32141884a71c3282797815e8976d90fb96326f47cfba94ea10735fad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c86a2fb4b5385403c14dc3c2cfe6880a6dec44feeb187ef1e7de62b76e80d7fc"
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

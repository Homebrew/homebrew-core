class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.47.0",
      revision: "39bd915f446068862cc3064edb6dbeee795785ca"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b05a0946cd1afb1d37457368dd7a376e4b0d9ecc191f41a9ff1fcfbde45948e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "798b6af5e8b9bd5b1c07cbf6f991eee75322044d05c368b9fcccbd7d6212391b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f542b52d2bba83d3121db84c75950220d2c2aeee54381dca8ae7572e4fb82f"
    sha256 cellar: :any_skip_relocation, sonoma:         "52456e8452ad779e7ab53743447ad1ed990072acbb9c4bbacfb5067632541c7c"
    sha256 cellar: :any_skip_relocation, ventura:        "10b1dce3627874e0344226257ed138620a70c38ab962f371a35ecd1ad9a091c0"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4f2c42a1effbe59fa03c40bf2b5ab08e5bbe0a1eff2a668ccf4290525671ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b75c129c6c54d4866206013b0e2fde8eb3759e7e7cb53dea4640eccc4f9c8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end

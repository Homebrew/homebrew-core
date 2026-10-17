class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.73.2/chezmoi-2.73.2.tar.gz"
  sha256 "0c137480901fae349ab8f1688fa881fd235d3708ac2ef5d800e0105d82632666"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2891f7de0a7d6d44a597437138008528fc2569b0754e3f076dbdc2384aa2ba2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e50c5629d36e3a3285c85f23dfe4e1e1596813c4ec898c026573ba303c48289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "500bf928f9cacea2ba03720cbb277da471a2a4eb2075f558fb18e86ff5e23c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "100898b6105ec4fa20640b4faccecdd6ebddf2d6c5b8574f57ff104c4581e1e0"
    sha256 cellar: :any,                 x86_64_linux:      "c55446a298a3f047e15bed1185aa7a11a52c5e2b530ef15690b7a43cc3984ee7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    output = shell_output("#{bin}/chezmoi --version")
    assert_match "version v#{version}", output
    assert_match "built by #{tap.user}", output

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end

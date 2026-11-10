class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.74.1/chezmoi-2.74.1.tar.gz"
  sha256 "4cfb8f635ea24b6e26f4a99ba8e84539c992df5b1b22adb1badc14fdbba5d0df"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c552d0c37e1b63f29f90e8b31bf4b448da2658d42f93f1d3c5eb3853e9458742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "701968fa48a7101edff4f2e203aa4f1463ad9911c82402447aa2ed78c3dbf525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7216833ea28bc44ae68aa524c55e655b4e3426940041d6fd8731ea659d44b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32eb93427c1f9374614c5abd6cbeb73672a32a43147b3b37699c4645477060c6"
    sha256 cellar: :any,                 x86_64_linux:      "1c2528c7ccb57b4de94ad5650379b2d59e34cdb760970803a52bd8f592ebc750"
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

class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.72.2/chezmoi-2.72.2.tar.gz"
  sha256 "88fcfa493c9b5011f9adb9a0ea04dfccbefb8017659aeed1eec4f728d8cbee9e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29a00a66a70003d5473902e59a58067e2e10e57d57cb3165bfafa70a72402f2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e02742cd33be869a57700ea308d3dd7175f8c33356c8631ac5cec4b648879f33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c553618e29c978c6993be65d31c26bf19698068b473c9a76e71e4dfb80e585d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "374b1fb89cabcebee42c09f5bc4adeebad6893817138d31a41f8fc900dd64c90"
    sha256 cellar: :any,                 x86_64_linux:      "5e5278a50cfd03658fe98ee70748a83a09dd9161f8dbec4bccc47732278897bb"
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

class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.67.1/chezmoi-2.67.1.tar.gz"
  sha256 "a188778fcff47715da8a5d179622b50c4c724edc7d0b30d5125b818a61ce4e29"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "468b403459471fa5f9df5a19cc51671899823ac7915f56bf8e3b6c6fe96302e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "996c0e50ab535382b7a513c703114feab793c1992c66e25beec88d4ac2520da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "968619cd94923a1698b0a084fe6c6ba2a39a3ffa77ff4a110ff403b61be3e1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "507ec84b258b296e8c44a393cce1f282a2fa5a4b546538c3992801758719ffba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28bf7f31dda7d21f1b9308d973f4c9a6a28ea8d1ae7228c38e734fa7296f1e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66838e4f2ce22dfce905b9d5c15d6036acdbb12056cb61cb2a1a23ebf237b618"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end

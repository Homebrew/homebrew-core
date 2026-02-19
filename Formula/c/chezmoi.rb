class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.69.4/chezmoi-2.69.4.tar.gz"
  sha256 "8f15cd2a11c5db756c0884f3692d24117fd467c1bcf54818d079b564d68a754e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "477ca8cbfa3bfb1c99e5152feba51ed033846e6beaf463c44aef9f0343289851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0ab8d58ad4dd08f6fa4e382111c6dbe2818360b4dd5429ab813b79f7fe6301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f64f19e2d5089c324ecf998bfcfa53a11c237c7283f735a9d2a868d0136f26c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4ea2ca5b130b381a323683cb3cdaec17c3a1ef4f59e4ff9ddd1cede7560967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f93f8ddf438ddb2dff5b4078d39992b4551c869ebb9453ff43c71bbfb4e59c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a045bfb884ffed1a8a7fd0928a4f3c98be46bfc9cf2b5919729fb718552bf637"
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

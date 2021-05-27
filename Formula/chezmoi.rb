class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.13",
      revision: "c6d1ef1398d1806e28f8db50ac014fc3a17835e3"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "904d9d4cc740fa7bf5f5e5ac50d9da971e3c316f73a75c7ce53506885218ff54"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d941f17abcc872412b19e795b94ad16d86e4159f5fa5d3bee3808fe472a2ae2"
    sha256 cellar: :any_skip_relocation, catalina:      "59c72b274478193ce0e4006eb19b8984d9ba0fd87a401be7a9f793fc0b3fed18"
    sha256 cellar: :any_skip_relocation, mojave:        "976afe882c57f1c9a9d7e2ea51d7bb5725cdedc8531a94ebce38aaaa707d2f94"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end

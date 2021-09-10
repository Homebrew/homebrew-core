class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.3.1",
      revision: "b05d33932b57f5ca04332f4b75c3fbf9d8905628"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "434985bfcca0003d48d85b71fa4090284cf6e86ab2d2b28027ad021aedca2fd1"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c00a8f7b608351af1ae893817804ede63c236e10564eb6d7522bf8fe797e1dc"
    sha256 cellar: :any_skip_relocation, catalina:      "1ca626beb540372c852f89b1e58457c6f963e9f4cc0b0985ccfb0297e2129034"
    sha256 cellar: :any_skip_relocation, mojave:        "b937c3ee0761209c97b64b928e4c722ea851a0c22c489e659eea1a75e76b85c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b64fa6e261039895043dd21082ca6bcc52e1b3c8c99f54c259ce0476c63fa02d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
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

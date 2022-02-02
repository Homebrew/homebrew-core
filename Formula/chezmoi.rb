class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.11.0",
      revision: "223f7111c2b3e6f90f4ac8af7f5ca0c35c9d4816"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6d5dcc5c6d976ce4235eef693fdae504b84e6f19fca76540c59e9c3be253298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16ca9de5cd7fac8a066b8ab3b5b5035e39050670ef0eac07062ae70a7a85977d"
    sha256 cellar: :any_skip_relocation, monterey:       "8e00549d51097bc99e10d0c09894f58bcf37e6e409ac75da60f7e7be7c71b6bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d162fb9b1f4fa05e67e30f8f375e64374eb117d48c14515c1d8cefc09a09ccb0"
    sha256 cellar: :any_skip_relocation, catalina:       "f122180a046698cbd0e14e12628d8093d9c1c96a7ddcc7bb4fed4d961ef12f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d03fad32b289a423146508a251947e3bcf1e8ec8ef76958a613cc2e6a73b77"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
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

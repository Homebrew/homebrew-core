class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.1",
      revision: "e0143cd0c7ec8b7bbe5f6a04d42a5dd5ed823b75"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a22a2ae48a4cb64701583e32bab37f3de394476c11eadf944311401d83af325f"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbde2b34b6e8b27ed77dc53d618e1edcd52361f8a5a63bda16186d052db76cff"
    sha256 cellar: :any_skip_relocation, catalina:      "4d356c5fd5e2872f7f20516fee039ab20aa74876b8b48251e6f45ca33bcf4314"
    sha256 cellar: :any_skip_relocation, mojave:        "c4ecdb5a6e1ab76a79f1ec6c522576e7e6b1eb1a4c9435eaf8b8edf80304f478"
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

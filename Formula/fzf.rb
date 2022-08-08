class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.32.1.tar.gz"
  sha256 "c7afef61553b3b3e4e02819c5d560fa4acf33ecb39829aeba392c2e05457ca6a"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8382d9b295388607f5683f58c68bb9601935fb1cd639161b5fe980423c127b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8382d9b295388607f5683f58c68bb9601935fb1cd639161b5fe980423c127b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "c294f52838622afbaf2ec8b7cfe0b882cebf202d63a48aecd9a22c288aa25f41"
    sha256 cellar: :any_skip_relocation, big_sur:        "c294f52838622afbaf2ec8b7cfe0b882cebf202d63a48aecd9a22c288aa25f41"
    sha256 cellar: :any_skip_relocation, catalina:       "c294f52838622afbaf2ec8b7cfe0b882cebf202d63a48aecd9a22c288aa25f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee47c63dbbc25d4499df6eeeac871e9f345b8d19ce03e97506e8d50dd6e156d"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end

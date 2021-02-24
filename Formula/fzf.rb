class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.25.1.tar.gz"
  sha256 "b97cf9ab528391a49dfa45b459c767fb2626ade9f3a3f99d0108d7274f2eca8b"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "133beca7affe4d543f5aba15b11886b8ad3fc34a5e9eb791452b1355bcb70ee4"
    sha256 cellar: :any_skip_relocation, big_sur:       "68e736426f331fde61f472219dfcee7e98eed1b286dfc04947295d9ff9e24dfa"
    sha256 cellar: :any_skip_relocation, catalina:      "bf62f2448b75495f44f5a59d05a304e4ec5b99c08ca656b14a6b0e9823969830"
    sha256 cellar: :any_skip_relocation, mojave:        "d523d435dc9ec2866d0cca2ba9cec1c28b4f92c5b56e664837ee1b798de1fc7b"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version} -X main.revision=brew"

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
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end

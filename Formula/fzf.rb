class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.30.0.tar.gz"
  sha256 "a3428f510b7136e39104a002f19b2e563090496cb5205fa2e4c5967d34a20124"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c776176e54740ed75d522099a7f20fd5ad9cc6043980ee42f513b8d776899b30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c776176e54740ed75d522099a7f20fd5ad9cc6043980ee42f513b8d776899b30"
    sha256 cellar: :any_skip_relocation, monterey:       "dadc361593396ced96c13d3695019a302d124e6cfe8ab6ffe65ba7877025a706"
    sha256 cellar: :any_skip_relocation, big_sur:        "dadc361593396ced96c13d3695019a302d124e6cfe8ab6ffe65ba7877025a706"
    sha256 cellar: :any_skip_relocation, catalina:       "dadc361593396ced96c13d3695019a302d124e6cfe8ab6ffe65ba7877025a706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "528898433166413e8b928311b25b05b172775eef02d299f55c4fa5ab8282170e"
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

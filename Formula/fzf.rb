class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.41.1.tar.gz"
  sha256 "982682eaac377c8a55ae8d7491fcd0e888d6c13915d01da9ebb6b7c434d7f4b5"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb689b5ce95152b1c03f87d0eba08578cbe4cec0a2f6310a6ee868cee42f80d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb689b5ce95152b1c03f87d0eba08578cbe4cec0a2f6310a6ee868cee42f80d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb689b5ce95152b1c03f87d0eba08578cbe4cec0a2f6310a6ee868cee42f80d6"
    sha256 cellar: :any_skip_relocation, ventura:        "9b6861079f3591465ac6e112c65cc29a79f1b52634a929fc6ff4d26ff2a15fa0"
    sha256 cellar: :any_skip_relocation, monterey:       "9b6861079f3591465ac6e112c65cc29a79f1b52634a929fc6ff4d26ff2a15fa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b6861079f3591465ac6e112c65cc29a79f1b52634a929fc6ff4d26ff2a15fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42b6b5086ff66dae5c201bac0dd4d0d5f9450186a4858371e2aab4011b298391"
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

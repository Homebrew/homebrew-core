class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.32.1.tar.gz"
  sha256 "c7afef61553b3b3e4e02819c5d560fa4acf33ecb39829aeba392c2e05457ca6a"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "475d6e470c916d77c2e41d5a6684e2d8152b541a992eeb9b7a979a28d71b86c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "475d6e470c916d77c2e41d5a6684e2d8152b541a992eeb9b7a979a28d71b86c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1159c0ae09118f29f568c854a654ac6004456bf747c19a7df8062ed4a41229e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1159c0ae09118f29f568c854a654ac6004456bf747c19a7df8062ed4a41229e7"
    sha256 cellar: :any_skip_relocation, catalina:       "1159c0ae09118f29f568c854a654ac6004456bf747c19a7df8062ed4a41229e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8ae9c530d8f4e44061f13886be6249b0a2b4bbb399ebab12b126ba4a76e3c0"
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

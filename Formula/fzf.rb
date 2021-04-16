class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.27.0.tar.gz"
  sha256 "265c569f3b0c3c210b45831b80d4fba260c5956f3ebf88d2c5c8f9f6d759e388"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ccc3f270e04389a9cc44d37c8d91a2b7cea3eba1d43c37e89a6cabc66898e2bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b0ca0f1f3bfbdfa55c4d7b7f0c3e11b07dd52db46f1862b54b742761c59c0e3"
    sha256 cellar: :any_skip_relocation, catalina:      "6a204ecb17beb7375a73569dba8c6ea1a097fa16a42b38a8fa456d205d107e7b"
    sha256 cellar: :any_skip_relocation, mojave:        "398c27f1750bec0973e9763b56194779915c2428fc6f7506392b2d30e16edb15"
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

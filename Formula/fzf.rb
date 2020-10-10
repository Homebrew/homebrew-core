class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.23.1.tar.gz"
  sha256 "07576e47d2d446366eb7806fd9f825a2340cc3dc7f799f1f53fe038ca9bf30f6"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c664f607fc5e4195f0f38f3695c8f0d4b25987244bfbe959b89913e1f8abbd8" => :catalina
    sha256 "407c80f7611fba1d97e443a00b6221b95a0e32b1c5231637f80fe875b00c3a6c" => :mojave
    sha256 "c8616880282ff6a94ec0b29451eceef1f511c55231e890a086888ac6a2f15fbc" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    system "go", "build", "-o", bin/"fzf", "-ldflags", "-X main.revision=brew"

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

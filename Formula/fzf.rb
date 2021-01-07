class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.25.0.tar.gz"
  sha256 "ccbe13733d692dbc4f0e4c0d40c053cba8d22f309955803692569fb129e42eb0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4cbab67d49b7472302b1809a8b6fb9569f3dfe8c17d92fba796810585ecb501" => :big_sur
    sha256 "e496f401d222aa84759ceedbb9174eaf0a0f8c9e89b7e04ad2b14cca9f77bfa9" => :arm64_big_sur
    sha256 "8be78a2d3f66016fd770a52760bfcea039a2fef131027c58df101e229b0a17c1" => :catalina
    sha256 "97c5f0acb223b9bc355169ca9bb76ee741d1b034c1766acf4b28c2fa2864ff32" => :mojave
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

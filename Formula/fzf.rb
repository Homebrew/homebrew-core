class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.27.2.tar.gz"
  sha256 "7798a9e22fc363801131456dc21026ccb0f037aed026d17df60b1178b3f24111"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae9fddf6be0736d872e48199d3f59517b48e4d5fa9fe609e61c6ca9f4dc2e582"
    sha256 cellar: :any_skip_relocation, big_sur:       "47ca85feb2e71a465580b5dd0912ed365c1015de175c81570309045abb847c96"
    sha256 cellar: :any_skip_relocation, catalina:      "47ca85feb2e71a465580b5dd0912ed365c1015de175c81570309045abb847c96"
    sha256 cellar: :any_skip_relocation, mojave:        "47ca85feb2e71a465580b5dd0912ed365c1015de175c81570309045abb847c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f76540decf6dff782146c728f007651b2b2c150ab7e06373ebdeec3522270e"
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

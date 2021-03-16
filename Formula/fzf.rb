class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.26.0.tar.gz"
  sha256 "a8dc01f16b3bf453fdc9e9a2cd0ca39db7a1b44386517bb7859805b053aa7810"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6301bb126f9d1d0858408ed428a368a95d61b65e310a9083cca3be66ec9aeac"
    sha256 cellar: :any_skip_relocation, big_sur:       "b711f6a7672111cfe55bdf2ff56182eece3362a34745700bf37082e6fdc43e46"
    sha256 cellar: :any_skip_relocation, catalina:      "99d6ed82769c08f345b286a676d6354b5a983699773b3c0878726291d093ceb3"
    sha256 cellar: :any_skip_relocation, mojave:        "ed36a1cfa7de25cbeb08b9fa37c1d6663dfa22218e65843dd1530605ba37d04b"
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

class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.27.3.tar.gz"
  sha256 "a0ad8dc6dd5c7a0c87ad623c0d9164cc2861489b76cb7a8b66f51cb4f9a81254"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950c2b25994b7cdbe3892d0145c4267832ff40659d2bfc5218d686d11b6a8d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950c2b25994b7cdbe3892d0145c4267832ff40659d2bfc5218d686d11b6a8d14"
    sha256 cellar: :any_skip_relocation, monterey:       "4eedbd23358ecd58646e57c4807ef72d50b3dc4e8409e1c493a69bee5b012271"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eedbd23358ecd58646e57c4807ef72d50b3dc4e8409e1c493a69bee5b012271"
    sha256 cellar: :any_skip_relocation, catalina:       "4eedbd23358ecd58646e57c4807ef72d50b3dc4e8409e1c493a69bee5b012271"
    sha256 cellar: :any_skip_relocation, mojave:         "4eedbd23358ecd58646e57c4807ef72d50b3dc4e8409e1c493a69bee5b012271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e7ca3e75119871c3916e866fdf4349bf4fc29cd2b2120ff4e657186e89a0a4"
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

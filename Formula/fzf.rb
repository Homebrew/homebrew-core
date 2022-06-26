class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.30.0.tar.gz"
  sha256 "a3428f510b7136e39104a002f19b2e563090496cb5205fa2e4c5967d34a20124"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cacbafa676ef1fea2fe91bad2e3ae6d2c05be3955a50ae58e5e30f57f131be97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cacbafa676ef1fea2fe91bad2e3ae6d2c05be3955a50ae58e5e30f57f131be97"
    sha256 cellar: :any_skip_relocation, monterey:       "08b9ea78a577ffcc3f5d136014f3e15ade8d3e25097252d52edfe0ff61c887cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "08b9ea78a577ffcc3f5d136014f3e15ade8d3e25097252d52edfe0ff61c887cc"
    sha256 cellar: :any_skip_relocation, catalina:       "08b9ea78a577ffcc3f5d136014f3e15ade8d3e25097252d52edfe0ff61c887cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f6a4d95f0dcd3707ab2327bf405a8e50be9e974a21e645bead11dc1cb7bd2c"
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

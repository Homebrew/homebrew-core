class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.35.0.tar.gz"
  sha256 "645cf0e1521d5c518f99acdca841a8113a2f0f5d785cb4147b92fcfa257a1ad0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c77151b51e8f9b79cc1f474c1c0436d06e8dcf0c121345301c1770cdef7d33fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7371e5a0e1ccf560b11d74d8bcb67b39893337e1ae14b5df06beabd04f8286ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7371e5a0e1ccf560b11d74d8bcb67b39893337e1ae14b5df06beabd04f8286ec"
    sha256 cellar: :any_skip_relocation, monterey:       "05015f38a023908e87ce6dbd00d103baa06d92bc568a366feab9898415895363"
    sha256 cellar: :any_skip_relocation, big_sur:        "05015f38a023908e87ce6dbd00d103baa06d92bc568a366feab9898415895363"
    sha256 cellar: :any_skip_relocation, catalina:       "05015f38a023908e87ce6dbd00d103baa06d92bc568a366feab9898415895363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bc9fac465609cac4c545340187d31dc8c3be5c4f0b30c4dd86223176c2cf38"
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

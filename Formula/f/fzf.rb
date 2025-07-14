class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "e990529375a75e9be03b58b6a136573b9fd1189c1223aaa760e47fcb94812172"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e844567c45c88135f82871b2475718f9024cfffc53c0635950da1ffa4f0978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36e844567c45c88135f82871b2475718f9024cfffc53c0635950da1ffa4f0978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36e844567c45c88135f82871b2475718f9024cfffc53c0635950da1ffa4f0978"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bf17d6d0da7d31d711f53e19e439be44068f6bc3e81669adfa9d092e27b571f"
    sha256 cellar: :any_skip_relocation, ventura:       "2bf17d6d0da7d31d711f53e19e439be44068f6bc3e81669adfa9d092e27b571f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe118c9d006351383bab176b554b3eb9623a7e5acdbd5b93ba562eed9a1eac97"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
    bin.install "bin/fzf-preview.sh"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https://github.com/Homebrew/homebrew-core/pull/137432
    #      https://github.com/Homebrew/legacy-homebrew/pull/27348
    #      https://github.com/Homebrew/homebrew-core/pull/70543
    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats
    <<~EOS
      To set up shell integration, see:
        https://github.com/junegunn/fzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end

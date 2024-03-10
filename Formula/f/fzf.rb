class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.47.0.tar.gz"
  sha256 "bc566cb4630418bc9981898d3350dbfddc114637a896acaa8d818a51945bdf30"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88645f5264dea945e346be3cb834f6f92802d8144a0dff3ef7814e06e19ed99a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d80a367c43510e77b4b0bb1470768a75400a80055326eec811f6278ce4e1b81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f748194182337b0aec61cfa765e6d95ef89d8bd77d0b311efbf07788dd2fc68f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ccb98d6ead61442af5c15be934895b4b9833e2809ddaef6946489f573696476"
    sha256 cellar: :any_skip_relocation, ventura:        "be45a7ef91f86e5d7aded48c73b9e45150bbbd7192554ec0c693ab8382c2ba32"
    sha256 cellar: :any_skip_relocation, monterey:       "b244bcf06736b8d362f9f0d6488c614edff001e3d6b23f296735d6d8e0855138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "299bdd9ae55a630d5bf92b4203c10c4732a6c17758ef67e0c50ba7f082dd346d"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"

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

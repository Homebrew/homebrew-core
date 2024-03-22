class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.48.1.tar.gz"
  sha256 "c8dbb545d651808ef4e1f51edba177fa918ea56ac53376c690dc6f2dd0156a71"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc4afd3c1576c055d53004cd7b464df0851291cb4afe2d2c51cdd6175c0bb7ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58ae799ffc3ed7e06dac105af60c2096e6996315aa7484cfa49c2200c789f1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee5bc5096dea57b0099a79cea63b5faabf12f01b1a42010f9206683d5136d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e5bd67c377e351b230ca46252630d1388c1ca10c1f7af97f252d04ce0dccf3d"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5764fbd3039153d4081210d9c3743b78d6c4362a29df9544418e07a1eafe0c"
    sha256 cellar: :any_skip_relocation, monterey:       "1e27d28d86cfe5b098bacb07380e732cd933d1f2d467de08c8fd4a9d87e9d314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0ab34b8c6d452896a09f8d422047b2b97b8d1b86b7013f0dcc9ee1349f250f"
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
      To set up shell integration, add this to your shell configuration file:
        # bash
        eval "$(fzf --bash)"

        # zsh
        eval "$(fzf --zsh)"

        # fish
        fzf --fish | source

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end

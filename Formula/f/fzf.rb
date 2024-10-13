class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "805383f71bca7f8fb271ecd716852aea88fd898d5027d58add9e43df6ea766da"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a2bba9c0344013459e6e19292e9307899a50f08a8c3f1309228fae67843d3a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ac2f272f6106c5266de224e982bcb9a05c291cfb84a6d797bc759f1a854f499"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ac2f272f6106c5266de224e982bcb9a05c291cfb84a6d797bc759f1a854f499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ac2f272f6106c5266de224e982bcb9a05c291cfb84a6d797bc759f1a854f499"
    sha256 cellar: :any_skip_relocation, sonoma:         "c964cfe2f826a26f2f7216938152489838480b1ca300b5a70889da9a8fe8e231"
    sha256 cellar: :any_skip_relocation, ventura:        "c964cfe2f826a26f2f7216938152489838480b1ca300b5a70889da9a8fe8e231"
    sha256 cellar: :any_skip_relocation, monterey:       "c964cfe2f826a26f2f7216938152489838480b1ca300b5a70889da9a8fe8e231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46cf359fa71ad2128170b543989fd28d9ceca2b6ca661e9de70b5d79f6ad9763"
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
        source <(fzf --zsh)

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

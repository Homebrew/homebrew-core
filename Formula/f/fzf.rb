class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.54.3.tar.gz"
  sha256 "6413f3916f8058b396820f9078b1336d94c72cbae39c593b1d16b83fcc4fdf74"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18acafd043413bfb61c6edef50bb70f9ff42b0748427b1f36e7466f772c54681"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a04b7d26d831530f6d053ef0adf5513b8eda7030e5a067d4154b7a7bb04e7438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f351cc6ffa324710c89da3093c18ac8495f57ddf2b948e382ceda744a51aa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4807b5b09a1d0af31e75aa3f749acdf84e29275be040953d16060b29b6572e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "e8d6cd2506a64b290525b6ed9641e39344a2de657490b7939e88814287fb12c6"
    sha256 cellar: :any_skip_relocation, monterey:       "6e501ed855756c98853a246c68e4b6ee23472365c3dcc1054ce11edc143ccbdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6addbb4c0a34e4325df4c754dc79c6544e13149c2bd8f6b813ce543e77b31edb"
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

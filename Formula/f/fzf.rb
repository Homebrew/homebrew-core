class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.48.1.tar.gz"
  sha256 "c8dbb545d651808ef4e1f51edba177fa918ea56ac53376c690dc6f2dd0156a71"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b8167eafa725b79900d14028b663fb76882f807b9bd184b960bcaf42f102fa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01d6a1a8a6e73b4b47684e96deece21c76a869d612370218fab17af585442908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5139e0e7fde60b17a0bddf0a018281d4e67e34535c43eab1af4dfc158380b08"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bbf0ed64f9d47e7f514515fa7ef93dd36d5c46a2fa3edbd8fdda4bc171288ba"
    sha256 cellar: :any_skip_relocation, ventura:        "9c160f544683e0bf914e47a3caf2f9c26faa05101f5599a2c9c4ea40f68cd52e"
    sha256 cellar: :any_skip_relocation, monterey:       "35e529aebc0d8ab1f8729c48722deba5f2ad28f4071c632ecfd8a21400c57960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165f28099ad098a9128cdfdfa31ceaa7913d990cd9e33574a16459f8eab51dc9"
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

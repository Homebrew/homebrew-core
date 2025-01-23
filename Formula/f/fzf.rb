class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "c49e5b13c7f3ee28ebc41ce720e48054287f11186212b2152434497a590f1a63"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da4ff05b5503234dbc25e575568c388a162903fc261bb8af148b93e3b879c6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da4ff05b5503234dbc25e575568c388a162903fc261bb8af148b93e3b879c6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1da4ff05b5503234dbc25e575568c388a162903fc261bb8af148b93e3b879c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c7732f6e652a32cb51e59ff1af700ece9759381c99a05d3a1b13fc42922f14a"
    sha256 cellar: :any_skip_relocation, ventura:       "6c7732f6e652a32cb51e59ff1af700ece9759381c99a05d3a1b13fc42922f14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad44d8fbfd736c4e500e80afaeb4f3e4b3876b491541a1ce91c9f0d5db322a0"
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

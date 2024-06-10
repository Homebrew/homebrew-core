class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.53.0.tar.gz"
  sha256 "d45abbfb64f21913c633d46818d9d3eb3d7ebc7e94bd16f45941958aa5480e1d"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f07ea86e64106fa20d553c2bc55ab51688eb3f420e87467d9ddfd0153906010e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed27a36aea432ac828bcc320cf204c8ccdf687b3f69cebcd8e49bc6ce15cc09c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f2431f067b24ef79fbffad7b72fc5164be879387df13661e2ffc2beba86c80a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c705f6d1677e9c33a1872731ff8e4a6fae34839cfda17ca0a4cb24a9f0b7103"
    sha256 cellar: :any_skip_relocation, ventura:        "5945e8a8323ef30dd6b047d57d7112530bff88d0fb48236cb958423e8c6be1d7"
    sha256 cellar: :any_skip_relocation, monterey:       "18f1c856a22b005b0be450d277d16daf09d369744876fd4f0691f452b080c507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81729c33eeb1f5092ec333ca4787bfeb90fa54cc4ec3650dbc4af0eefad530fa"
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

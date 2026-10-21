class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.74.5.tar.gz"
  sha256 "5529d08897b85ae773695787c811ff9c9eeee32419c8a297fa1dbe586ed0a27e"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17d944658dd8fb782733090891d923cf28815a6e93f8aec35ba07fec1fedb542"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17d944658dd8fb782733090891d923cf28815a6e93f8aec35ba07fec1fedb542"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17d944658dd8fb782733090891d923cf28815a6e93f8aec35ba07fec1fedb542"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0749697638cee94fd9a1ffe0bc11d54154efa4eef051bbaef2b1868f064fa6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "af83752b94daa51fc490068921234d3609cfc8e37650696bf00743b558d6c522"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X main.version=#{version}
      -X main.revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
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
    assert_match version.to_s, shell_output("#{bin}/fzf --version")

    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end

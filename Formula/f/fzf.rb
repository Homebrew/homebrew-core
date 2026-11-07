class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "165f6e0c1b9ba082346233681e3f1d1374e37f9fd3c1d7b6dfe09659ab893faa"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e342bee4a3cab8045bb510dc5b4474b58a5a73eb7e1657e3caba200b3f3b5d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e342bee4a3cab8045bb510dc5b4474b58a5a73eb7e1657e3caba200b3f3b5d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e342bee4a3cab8045bb510dc5b4474b58a5a73eb7e1657e3caba200b3f3b5d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e9a0069d97c7c471b721e52772770ac38e1509320fcc8435d3802992842128d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d862ae3b5b62d73d0a647c0b590fe806b3c9b33ff265680720cd4b4fb2e9eb6"
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

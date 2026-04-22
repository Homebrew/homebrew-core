class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "2420f4df1e7c3207a5a74b30c32ff3f3fa88ab6e2eb9e0da92cb27905271a525"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f41180c7f3a987af790e6aecb8e884918feb1b3648ea8baeb9e7cad9838420f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f41180c7f3a987af790e6aecb8e884918feb1b3648ea8baeb9e7cad9838420f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f41180c7f3a987af790e6aecb8e884918feb1b3648ea8baeb9e7cad9838420f"
    sha256 cellar: :any_skip_relocation, sonoma:        "014f5962cb37c92d7f1213a8d275874050fd5033fa2aefebfd8f9e9537afbf9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0680573734263ef28e404e6f6475b7a68fceca130acaf8c678c89eb6067497b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d64fe5e3c85923c554e79bd94f833eedd2edee1e18b002f234cda125ba34d76"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
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

class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "a99e0df4dfb6228c8af63a2f99f39f7476b7da614833141be30a6b3a3f9d440f"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a827b08efd0eaef42cb8e30b4b083d0add8ca9e1597074bd8b11cba175a5c62b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a827b08efd0eaef42cb8e30b4b083d0add8ca9e1597074bd8b11cba175a5c62b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a827b08efd0eaef42cb8e30b4b083d0add8ca9e1597074bd8b11cba175a5c62b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b484a00f87a8d3804de7acabba2c73bbf1584fde07d8e5ab61139d6364cfa2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ee3e993e819d52aa8684ef224126b5efeda16025557b9ee728e31e3d444019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109c13f8befd3eec002ae9ad129f3b83c1fc01f8202a27cbd5de6dcdd958b55f"
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

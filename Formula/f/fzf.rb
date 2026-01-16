class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "da72936dd23045346769dbf233a7a1fa6b4cfe4f0e856b279821598ce8f692af"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500afd6091b289afa9ab2cc88d3bccdd9ba5c47d267316a95a74e9dbe32af2ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500afd6091b289afa9ab2cc88d3bccdd9ba5c47d267316a95a74e9dbe32af2ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500afd6091b289afa9ab2cc88d3bccdd9ba5c47d267316a95a74e9dbe32af2ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "48b7ed06742a75bf050991cb89be475fe8bd70e99d1821dca637e0e5cddcda1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ace29627cfcf99ca30b210298f920b10ffa6e2ff7e34f2949625a47234f96965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f7246b9c58e21dc29690962edc0b4c2b976912f740f6f877c915bc903b1d2c"
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

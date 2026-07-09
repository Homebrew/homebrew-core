class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "55ab5f2256edd8890f81d407b63d3a3e81cffe10e318cd196031dc85efdeb079"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee5614638687fd4f09f38f9193e3a47c2f6d3fbabf9468bceebdbd8066fa62ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee5614638687fd4f09f38f9193e3a47c2f6d3fbabf9468bceebdbd8066fa62ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5614638687fd4f09f38f9193e3a47c2f6d3fbabf9468bceebdbd8066fa62ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb5fd07a6dc165bcdf91697c9e11a998a5ee262c58e40a556d7f12f38800040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45283958fe62353ddcfacf15a519f8d5dde15ee990b67a96783dda8d1d3bf384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17cd2df4eb9bd0a6ea948de117401d9538c862a5494d74517f7c195e7dcaecca"
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

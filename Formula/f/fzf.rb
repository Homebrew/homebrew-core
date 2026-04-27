class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "ca5ce083cec5187503ceb96d837c20d8efde85f03e62bba3a8890f8da526f2fc"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df51e679ccd58384a5396013a6b046f44ef5327f8d8647ca961a5c7b47a5f84c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df51e679ccd58384a5396013a6b046f44ef5327f8d8647ca961a5c7b47a5f84c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df51e679ccd58384a5396013a6b046f44ef5327f8d8647ca961a5c7b47a5f84c"
    sha256 cellar: :any_skip_relocation, sonoma:        "069cf6b7c57089ad4f646075bb88733b61222f9c662470711efeda5a6f309667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e30781e82c53992d1933631ef6cbbeb2b3cd03b35b6735d91d5043488c6625f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beea83c4c21f5d6ecb10de001e178b6b3002c13813f4b66ada98b60e6a5c4b89"
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

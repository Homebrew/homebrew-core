class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.74.4.tar.gz"
  sha256 "1046857c337f5bd05f6fa482446b5a42a011615105743efbe4efee0970b24bb7"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1094281c70e4304dd4e52bb5799dd0a15c8a229c1674ec1000de6238cc75e9fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1094281c70e4304dd4e52bb5799dd0a15c8a229c1674ec1000de6238cc75e9fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1094281c70e4304dd4e52bb5799dd0a15c8a229c1674ec1000de6238cc75e9fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7104102c94beaf32c253a7f31dbdb961fd1c773ca81c3aac8455d81b97a09ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "93912e54112d0acbf7790250e3cbef36a7bbe30526a45379505249d652288121"
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

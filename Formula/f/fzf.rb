class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.74.1.tar.gz"
  sha256 "ba37120bbe45966c6eba6a00c8ea64b86c3c57e349cb55b1c3e0f522976fd978"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdcc7137db527f0842d3626e36292ca76c20f9b0c2dc23c9f9fb64e35200743e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdcc7137db527f0842d3626e36292ca76c20f9b0c2dc23c9f9fb64e35200743e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdcc7137db527f0842d3626e36292ca76c20f9b0c2dc23c9f9fb64e35200743e"
    sha256 cellar: :any_skip_relocation, sonoma:        "92ddb7321785cd7e7b743cec426ae7554ed79632e3febbd908d9c4eca023bdc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb416786bc6c35fcbf0a791d4cc7e61c1541842b57a4d67b9e2db8e81884a282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2c173be2d80793d3215dc760ef70153da800e9bb639c711bcde3733def57ba"
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

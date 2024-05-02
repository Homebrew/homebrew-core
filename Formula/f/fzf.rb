class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.51.0.tar.gz"
  sha256 "64b3616700cff7b00785607771fc05023219eff24c54981e2497977fc7a6dd76"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d61d9d5f4c06b6d85664d5a699fc297e8e0a38e33879fc500c68dcd17318d81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6976460913e786d0979ec44f780fcdd041ff3be136a0d9e036015dd377b77e94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e1d8c4b7791b85a1dbee61a9f18aae34656ff9d98086c0ae2247e7d3b7554a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7253c7b4024f466258da7946b72ed72e597d31d32f0350799f5fe2792a86e0f8"
    sha256 cellar: :any_skip_relocation, ventura:        "d7f1aa81ae6113036c1f7a5e8cd99d27333b588dede0b464e9628ab1111bfb49"
    sha256 cellar: :any_skip_relocation, monterey:       "224b4d33b31eba6fb4b6b7300c75e26ec2fbf1b34cef0b268ab15e96ed092fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c7644d1746b90ecfbf6c9d91f9b8897b909f961f5f27d621b42c5553f33c08"
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
        eval "$(fzf --zsh)"

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

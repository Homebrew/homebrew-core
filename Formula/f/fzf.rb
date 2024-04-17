class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.50.0.tar.gz"
  sha256 "3dd8f57eb58c039d343c23fbe1b4f03e441eb796d564c959f8241106805370d0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee0cb03df39480274049dd74db3b4debc0a1c368dcfb5919fbe94aa5b7ab4703"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081e59919fd672bdce4c8b02228a71f63084bb699eb8bb0076bfaeaa6c3674d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2870cc2f40e7f2a08ec71f5b121d56946937b096b4e5d794d265ccfe26bcc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3be141e37ce64649ff4f568a3e16db95889dcdd12ec19b0f5fa823b13ace92e"
    sha256 cellar: :any_skip_relocation, ventura:        "c8d8a586081745f077ce8346ecc58688582fd9946a5f5d152983492e5c95b378"
    sha256 cellar: :any_skip_relocation, monterey:       "3acc95f5a2732f02f8635bf9b74e6097d5a0f595723da7d4dd2a7aeae1345a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9537887f79d1b2be96fe2028d2d6d4834aa89e3335dc872d642b3f793764992"
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

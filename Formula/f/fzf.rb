class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.43.0.tar.gz"
  sha256 "2cd3fd1f0bcba6bdeddbbbccfb72b1a8bdcbb8283d86600819993cc5e62b0080"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29f422ed068d49980a67acd48b0228832c69844e002678c25c7208add139fc87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faa625c9d736126f7f7de58f29c312a9b66de612e4af8ce8de4739a58a017d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "025a61c1a7feec78622d77ce6b4361db0881ab903c65ef64b4fff23af147be02"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9a6dff16c37485766015f536323924b998f8c38a9050267a14f86efb7475b0"
    sha256 cellar: :any_skip_relocation, ventura:        "f913b93bab5eef01ad1fc420236de35476042cdc6460314b47e96d3dfb019871"
    sha256 cellar: :any_skip_relocation, monterey:       "41e11aa6dff0aaae489d2f7d25633c833ae831d0bb6e5c78587abdb54777aabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98899999ad198ebd7d67602ac6c139c627a85c7bde89292918770a56e73fb8b5"
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
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end

class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.48.1.tar.gz"
  sha256 "c8dbb545d651808ef4e1f51edba177fa918ea56ac53376c690dc6f2dd0156a71"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "044cc3a8687caaee048b542204f2c56de0bafc628dc27a9279df154c327c8510"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1999a4eda6abbee68fd6e73e94d8c455ab79150af11fae89a63f23891b059a96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49769cd220e714b38d23b31c90a54401d81ca51249e78464722e37b2da543771"
    sha256 cellar: :any_skip_relocation, sonoma:         "c208eefdf776ab36c9f65ab7585b51e96ea91fc231e397ea2e5165fbc5d3798b"
    sha256 cellar: :any_skip_relocation, ventura:        "2eee2c887f24d28feb71802b3f55c0aa132d8cbeb82ff09e221c440628033b16"
    sha256 cellar: :any_skip_relocation, monterey:       "2b53748b06f07aa0a0f4b455f51ef6b416896f4dca29f524ff8a262570e347ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af96775adac3bbb73d8c76b18bc03492dfd46737fa37bc2c2038fdcd43eb43ad"
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

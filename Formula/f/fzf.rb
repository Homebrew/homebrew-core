class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.65.2.tar.gz"
  sha256 "53b7e0077833f96ae04fd1e312ed65b2d5c427422b652dd3ce6c2d1702f8ce56"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de1ff196fe92b40d399e927a03c8cb1e770d02454f0e9489c9691e32a1b289e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "444cf406b792fd47ffca3eb671e5be08407e62dfa23609e561a85d1b27da39b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "444cf406b792fd47ffca3eb671e5be08407e62dfa23609e561a85d1b27da39b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "444cf406b792fd47ffca3eb671e5be08407e62dfa23609e561a85d1b27da39b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc56f1296a892608217d51eaffd79b9ee9c51a3972ff374f50bd221662561d2c"
    sha256 cellar: :any_skip_relocation, ventura:       "fc56f1296a892608217d51eaffd79b9ee9c51a3972ff374f50bd221662561d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a504bef45f3fd12faeee610d9918bb38fa9e794a965f246b49000efd018e593d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f99d66e0276d4cc4decb4a7291b54546abe2c93331ec41d50215ae4c3dbba7dc"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.revision=brew
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
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end

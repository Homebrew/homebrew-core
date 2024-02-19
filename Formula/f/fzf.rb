class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.46.1.tar.gz"
  sha256 "b0d640be3ae79980fdf461096f7d9d36d38ec752e25f8c4d2ca3ca6c041c2491"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa98d4e9bfcb82ff81f42d23f1944ac56ee3bae5d8e44627a764d0d643fe2a08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9269ef300b9fbc0fb3e88f9f0dd262602655fb13783bf148d785f9b93624c8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "928b58a367f41f39f85a211f20c19286f8ea7d05ab1c303c6d749b2e439b95a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f267b893cfeb9ffc33c4722c82fff589e40dca418cc8beddc9ff787cf8080bca"
    sha256 cellar: :any_skip_relocation, ventura:        "c3bf340555075c036d0df533b845908518c64dbf21d682fb85baf97f178785c0"
    sha256 cellar: :any_skip_relocation, monterey:       "fb616e6906d5dc39d0e83e5e9197cc0984b4d14a9c5805830f4443a262d5f629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d2690cd2e82cd9c814a33e5dfc1f90bec1b579c5cf2e104626bb1dcfcc2864c"
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

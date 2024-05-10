class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/0.52.0.tar.gz"
  sha256 "d1f2c32b4f095457fdd7c22fe51ac99260ac8d066f49d5dec4f0e097a240dbc0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d7de574964a56adc7335909e624eade4f3dc268c88145722858ad03f2a20523"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e890fe2d3936117b38ced7e0341376ecdb66f09d1cc715fa22ef3d5d2d1f466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82dc815ee5bdc54c7ca5fe8ad4da899bee0824b15b79dd461a2fe4aa57fa7fa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "21b442909a43815b29aa1d8d3f50f21a5f0b300357e4b54328e25eb814d89cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "be22d016c33fb50e913224e86b913afebbe252b2dadd34c80908fdafe252209e"
    sha256 cellar: :any_skip_relocation, monterey:       "388a49b3a0a3476b3fce0f27822b678ed79cfb4270d241b1b1ab2902a2a3943d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3366291cbb3ee80312f6136f99e008e9cf411d1bd13deec8420cca679c1b6235"
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

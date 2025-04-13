class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "702e1886dab359a1dab361b372c1ac05b2a1ed5d916aa0fbc08e8269a53a5171"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec875e3b9fcd20ca5933e636adb439159efb1ae1a5e370c37c9df89333720fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec875e3b9fcd20ca5933e636adb439159efb1ae1a5e370c37c9df89333720fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dec875e3b9fcd20ca5933e636adb439159efb1ae1a5e370c37c9df89333720fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6e81cc16dd7b3dacffaab44e4c1b1eddd67304ddce8eae6dfea0c52d23551b7"
    sha256 cellar: :any_skip_relocation, ventura:       "b6e81cc16dd7b3dacffaab44e4c1b1eddd67304ddce8eae6dfea0c52d23551b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936a327289577dd35a8ac31c725b7fadb81e39abf88ecb77c368d54b6a7724ce"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
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

class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.43.0.tar.gz"
  sha256 "2cd3fd1f0bcba6bdeddbbbccfb72b1a8bdcbb8283d86600819993cc5e62b0080"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1990643a6ff77e1933f4767b2412bcb472537a722c62bb3ae85aa6e1659b03f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "007ac5ffcfa1cbf733393fe35d5daf3647e07865f04d31d6c442fb8de936d219"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007ac5ffcfa1cbf733393fe35d5daf3647e07865f04d31d6c442fb8de936d219"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "007ac5ffcfa1cbf733393fe35d5daf3647e07865f04d31d6c442fb8de936d219"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b14dff6cfd3c1577d37b4120cd567107958f16eca81f69cda073417c6850055"
    sha256 cellar: :any_skip_relocation, ventura:        "5cd9be92ee93dd44fecaaec2528656d609ef968ca1529fbf01720afbff5dfdcd"
    sha256 cellar: :any_skip_relocation, monterey:       "5cd9be92ee93dd44fecaaec2528656d609ef968ca1529fbf01720afbff5dfdcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cd9be92ee93dd44fecaaec2528656d609ef968ca1529fbf01720afbff5dfdcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7586893fbacc5e1755ecb44dae017b283bd45a6a28017409396ea950116dd3"
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

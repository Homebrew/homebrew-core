class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.38.0.tar.gz"
  sha256 "75ad1bdb2ba40d5b4da083883e65a2887d66bd2d4dbfa29424cb3f09c37efaa7"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52131f8f614aad62fffa59b2e6beca914c126c959cdb9c00b98d91d163608b69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da0b0e7475c32544f1627ff3b4d341c0cb882ab9933f4c22d195260cdbb49b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf5b0b66c348f1492a7ada7e92ea0e922945576a2caa0d6449cf1a5500db3fd8"
    sha256 cellar: :any_skip_relocation, ventura:        "16923e95ca9d8eca2390fe87b5622df9c2a563d89fcf7a402b76ac190f2ab698"
    sha256 cellar: :any_skip_relocation, monterey:       "9f8e47a9c8cd30d1550cbc8d7eefc36a0e13a4246f7d16f07cece76425fab687"
    sha256 cellar: :any_skip_relocation, big_sur:        "d70cc88f82d3f106960070c2f0c158b4c6d6483aa5b71feb91ad284bbb9ddee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808f350b43a5e54b13d528c97862b735502b8eac71f8877321ae58657ed6e396"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
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

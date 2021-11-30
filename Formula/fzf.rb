class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.28.0.tar.gz"
  sha256 "05bbfa4dd84b72e55afc3fe56c0fc185d6dd1fa1c4eef56a1559b68341f3d029"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f332e7c67b385d437ec7c7e89f70fb3df2241110a78e9a431fba6316d925a428"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f332e7c67b385d437ec7c7e89f70fb3df2241110a78e9a431fba6316d925a428"
    sha256 cellar: :any_skip_relocation, monterey:       "04b9060dad2714767d95e19a1d3d7fdd0afe0f35643f5e72936002010060be74"
    sha256 cellar: :any_skip_relocation, big_sur:        "04b9060dad2714767d95e19a1d3d7fdd0afe0f35643f5e72936002010060be74"
    sha256 cellar: :any_skip_relocation, catalina:       "04b9060dad2714767d95e19a1d3d7fdd0afe0f35643f5e72936002010060be74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055d03f36d01613b6b46fb1dfd5c8ab845639afb6c564388baf2fa8363838281"
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

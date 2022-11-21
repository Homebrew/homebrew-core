class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.35.1.tar.gz"
  sha256 "d59ec6f2b6e95dad53bb81f758471e066c657be1b696f2fe569e1a9265dda8fe"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7609e0c088fdc710b95226a1c5863cd967a17f30a42fd4a4591cd86d0e879a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7609e0c088fdc710b95226a1c5863cd967a17f30a42fd4a4591cd86d0e879a7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7609e0c088fdc710b95226a1c5863cd967a17f30a42fd4a4591cd86d0e879a7b"
    sha256 cellar: :any_skip_relocation, ventura:        "f5523af9227445be1e5892f5642fb1292ee6e184785823cb5a09dd8f2d1f1b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "f5523af9227445be1e5892f5642fb1292ee6e184785823cb5a09dd8f2d1f1b6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5523af9227445be1e5892f5642fb1292ee6e184785823cb5a09dd8f2d1f1b6d"
    sha256 cellar: :any_skip_relocation, catalina:       "f5523af9227445be1e5892f5642fb1292ee6e184785823cb5a09dd8f2d1f1b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13a64711bd6ef74c309f94a61c1d918ee0c726b1d19e36e1a8679669add3585"
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

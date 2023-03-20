class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.38.0.tar.gz"
  sha256 "75ad1bdb2ba40d5b4da083883e65a2887d66bd2d4dbfa29424cb3f09c37efaa7"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25241d91663f4569c6af7e81e02232b9ca90ab7c341d1491033e639018cd9b3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb62f190419f9a94c50e2895b85e07648f0a8be895b6b77fc60441d81e566ddb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "044922edb0f71774463fdb271ad15ebde33396719f2df897f5ddd6c97c43855f"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e25ecad5ab8cb14170dace4308c6eecf7b3b14c3a008467dc70c5f2b53d3e6"
    sha256 cellar: :any_skip_relocation, monterey:       "8deb63a1bba33df24dc41b4423726230d2f6cebd55a3f2031a72b64c7d4847ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad97dc2282f36dd5ffeee52c0a3d8eef4fcc6df29f2d902c99ecc6201a752b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f4e066283a232e101188d8a0781c73768bea8cd5d1981c6632a05884308992"
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

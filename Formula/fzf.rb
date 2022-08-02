class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.32.0.tar.gz"
  sha256 "3502c15faeb0a6d553c68ab1a7f472af08afed94a1d016427a8ab053ef149a8f"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "325e796e003bf8eb0f42ab443b7851c41a2cb8d97aaeae6fce9e7fdd8348fae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "325e796e003bf8eb0f42ab443b7851c41a2cb8d97aaeae6fce9e7fdd8348fae6"
    sha256 cellar: :any_skip_relocation, monterey:       "243e95d4e15d0c9dbfd2dfb8d183cafcbd9f4eaf4fd197660f86b79f7e817ef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "243e95d4e15d0c9dbfd2dfb8d183cafcbd9f4eaf4fd197660f86b79f7e817ef8"
    sha256 cellar: :any_skip_relocation, catalina:       "243e95d4e15d0c9dbfd2dfb8d183cafcbd9f4eaf4fd197660f86b79f7e817ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5ada0c11372a8cc6c3ac4be814b9764275cbda578df96c0bff3f1ea69e3768"
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

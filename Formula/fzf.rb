class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.34.0.tar.gz"
  sha256 "5bfd2518f0d136a76137de799ff5911608802d23564fc26e245f25a627395ecc"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c060989039ef838c48542fe25b68bf45a874f10b3ff8c6d70e5726382936e5b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c060989039ef838c48542fe25b68bf45a874f10b3ff8c6d70e5726382936e5b6"
    sha256 cellar: :any_skip_relocation, monterey:       "1f16e48fca570e858b8fa11c9eef4c561f7796945a5355feb1a69f9aece42f16"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f16e48fca570e858b8fa11c9eef4c561f7796945a5355feb1a69f9aece42f16"
    sha256 cellar: :any_skip_relocation, catalina:       "1f16e48fca570e858b8fa11c9eef4c561f7796945a5355feb1a69f9aece42f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1c9f868dfbffa832b89e1db57883efd9015184a0093762ee319e5d6c2bc6d1"
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

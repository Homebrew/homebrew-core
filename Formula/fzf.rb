class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.35.1.tar.gz"
  sha256 "d59ec6f2b6e95dad53bb81f758471e066c657be1b696f2fe569e1a9265dda8fe"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb01ba4dbad709af6fdc8d3c229b1112fa475c43966718bd7279dccb5876e9b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb01ba4dbad709af6fdc8d3c229b1112fa475c43966718bd7279dccb5876e9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb01ba4dbad709af6fdc8d3c229b1112fa475c43966718bd7279dccb5876e9b5"
    sha256 cellar: :any_skip_relocation, ventura:        "b6a1493bff4cc64c2c40762d73d253127de3eec5ce278cc70500bbf59a9d830a"
    sha256 cellar: :any_skip_relocation, monterey:       "b6a1493bff4cc64c2c40762d73d253127de3eec5ce278cc70500bbf59a9d830a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6a1493bff4cc64c2c40762d73d253127de3eec5ce278cc70500bbf59a9d830a"
    sha256 cellar: :any_skip_relocation, catalina:       "b6a1493bff4cc64c2c40762d73d253127de3eec5ce278cc70500bbf59a9d830a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697afe72e5bb5df78a6bfb36d7692a9096ed6b1710c425502fdc7b9dd356bc54"
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

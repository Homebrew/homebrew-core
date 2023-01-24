class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.37.0.tar.gz"
  sha256 "0044809beda82ba1a6936d5472cb749eef34785e8ecd4694936e39bf0ca9258b"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4318b9dc847dfbad8c7cc1c7add6f1e17b7d9edca14d571691e3dfb70007fe7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c833632bf4d2b2a91bdd7e695ba3da0f817d26a7633a30f01beb2c14320437e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e2e88a803296a48e10b2b5d6066cafe2aa5209ea8c78c06ab97181375326197"
    sha256 cellar: :any_skip_relocation, ventura:        "75814bc44a3dff0980004ccb48628dd1b1972b1128248570d2ab794402538fd8"
    sha256 cellar: :any_skip_relocation, monterey:       "ad176f33415245041d17dafe05f44c9586aef536b5c06e7550e9af8fa2955b64"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb3ccd2a9c9eacd43c3c3c57d11538aafce01b560776c441e1fd90c1e8373dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1d12c390a9f147122e4f8fbec2d9daf58e8580f55d361ac63e8518fd93928df"
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

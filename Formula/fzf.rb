class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.16.8.tar.gz"
  sha256 "daef99f67cff3dad261dbcf2aef995bb78b360bcc7098d7230cb11674e1ee1d4"
  revision 1
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b639612cd777a1e7347a8a89a357ae8cb7f0ee2a65a2f73c70907bf96f63a03" => :sierra
    sha256 "4eb00250956dd5f1024f8385da7426befcdd3c989a385acb40f2d5004e10dd1d" => :el_capitan
    sha256 "df146b34ec070efa9a45a598dd745b448f2c26210f7d6300bb5956f236a3cc29" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GLIDE_HOME"] = buildpath/"glide_home"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/junegunn").mkpath
    ln_s buildpath, buildpath/"src/github.com/junegunn/fzf"
    system "glide", "install"
    system "go", "build", "-o", bin/"fzf", "-ldflags", "-X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats; <<-EOS.undent
    To install useful keybindings and fuzzy completion:
      #{opt_prefix}/install

    To use fzf in Vim, add the following line to your .vimrc:
      set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end

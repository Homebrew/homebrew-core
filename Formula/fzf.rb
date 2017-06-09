class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.16.8.tar.gz"
  sha256 "daef99f67cff3dad261dbcf2aef995bb78b360bcc7098d7230cb11674e1ee1d4"
  revision 1
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "81ec0a71e0d302ff73d384c10b00aec41f6400a1eff4192dbbba7be390a0206d" => :sierra
    sha256 "e6b07839476ef71b8e61a6500a5f603399fb816bfb30090d56643da66bd0d432" => :el_capitan
    sha256 "e7167879c97aac2d9337cce777d6f315b07df7b1c316114d6c4d3362134ffb58" => :yosemite
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
    (testpath/"list").write %w[hello world].join($/)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end

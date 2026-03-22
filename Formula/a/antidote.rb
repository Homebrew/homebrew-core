class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://github.com/mattmc3/antidote/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "885d5bf2789f6a0efc3850e61c68028919015f6f63a47293b5604beb87533563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ae2d0c59f2a35ed0a83f28c243bf04ed5941e1bcb57a23fa2f5ef24e7c8cc1a"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "antidote"
    pkgshare.install "antidote.zsh"
    pkgshare.install "functions"
    man.install "man/man1"
  end

  def caveats
    <<~EOS
      To activate antidote, add the following to your ~/.zshrc:
        source #{opt_pkgshare}/antidote.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write <<~SHELL
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~/.zplugins
      source #{pkgshare}/antidote.zsh
    SHELL

    system "zsh", "--login", "-i", "-c", "antidote install rupa/z"
    assert_equal (testpath/".zsh_plugins.txt").read, "rupa/z\n"
    assert_path_exists testpath/".zplugins/https-COLON--SLASH--SLASH-github.com-SLASH-rupa-SLASH-z/z.sh"
  end
end

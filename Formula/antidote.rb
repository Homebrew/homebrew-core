class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://getantidote.github.io/"
  url "https://github.com/mattmc3/antidote/archive/refs/tags/v.1.6.5.tar.gz"
  sha256 "dfe6553db83abcbe74c3026449f9b00bda51465d270cce6d7a6baa0dc8f208a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4368329545305c378145141d00466cf4a2bdb12bbfbc456f8c07655e4f02a4cd"
  end

  uses_from_macos "zsh"

  def install
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
    (testpath/".zshrc").write <<~EOS
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~/.zplugins
      source #{pkgshare}/antidote.zsh
    EOS
    system "zsh", "--login", "-i", "-c", "antidote install rupa/z"
    assert_equal (testpath/".zsh_plugins.txt").read, "rupa/z\n"
    assert_predicate testpath/".zplugins/https-COLON--SLASH--SLASH-github.com-SLASH-rupa-SLASH-z/z.sh", :exist?
  end
end

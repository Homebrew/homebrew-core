class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://github.com/mattmc3/antidote/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "c9c4f4f7ba2e696e80bc3e4c7df184389641f5aaf5ede660f9ce5093d37efa03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e8a448094c1b9aedd30a8fece55851588b4ccbbeae2bd972a0d899ecd4447f4"
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

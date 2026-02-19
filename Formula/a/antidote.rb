class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://github.com/mattmc3/antidote/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "0c095f74fefe67d4262c01661c34775c23a5303fac445f8591018af6e7b39862"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed3c6d6d6ab2c404f978e4d78e0a5cde924abbbc91dcd28c0999532d75b8e6f0"
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

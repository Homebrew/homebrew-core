class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.0.3.tar.gz"
  sha256 "884092b4ed67f01e407f6354ad2a826797b6a3eebbf8b55cfa1833bdd766b3f4"
  head "https://github.com/zsh-users/antigen.git"

  bottle :unneeded

  def install
    share.install "antigen.zsh"
  end

  def caveats; <<-EOS.undent
    To activate antigen, add the following to your ~/.zshrc:

      source $(brew --prefix)/share/antigen.zsh

    EOS
  end

  test do
    (testpath/".zshrc").write "source `brew --prefix`/share/antigen.zsh"
    system "/bin/zsh", "--login", "-i", "-c", "antigen help"
  end
end

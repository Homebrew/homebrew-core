class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.0.1.tar.gz"
  sha256 "0b5ec8233a591ec6742446b9334a91ccf23020b1c0e52b4b70ae895c298071a0"
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

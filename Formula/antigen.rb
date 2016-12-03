class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.2.4.tar.gz"
  sha256 "139654e56f270a49749958c39b1a186f1c1369fc70b998127f146a52c3a4953c"
  head "https://github.com/zsh-users/antigen.git"

  bottle :unneeded

  def install
    pkgshare.install "bin/antigen.zsh"
  end

  def caveats; <<-EOS.undent
    To activate antigen, add the following to your ~/.zshrc:

      source $(brew --prefix)/share/antigen/antigen.zsh

    EOS
  end

  test do
    (testpath/".zshrc").write "source `brew --prefix`/share/antigen/antigen.zsh\n"
    system "zsh", "--login", "-i", "-c", "antigen help"
  end
end

class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.0.2.tar.gz"
  sha256 "f25bc00b48f309e58bb7247949d98d3223d414bc9cba0cb0189f14c825fc0594"
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

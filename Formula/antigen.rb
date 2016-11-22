class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.2.3.tar.gz"
  sha256 "47481eae99dc79589552def3899404e9786b62c28948f2472eeead93ff6fc487"
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

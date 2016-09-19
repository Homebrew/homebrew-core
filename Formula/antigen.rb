class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.1.2.tar.gz"
  sha256 "cd39d5d325a3738759013b4835755bedaff4f2558419ad7fc35155b0ec988ea6"
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

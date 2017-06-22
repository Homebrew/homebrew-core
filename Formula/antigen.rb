class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/releases/download/v2.2.0/v2.2.0.tar.gz"
  sha256 "09aa0e8c62ff23543dc701c349632d347de17a5b7a1629e6ab75c991047dd96e"
  head "https://github.com/zsh-users/antigen.git", :branch => "develop"

  bottle :unneeded

  def install
    pkgshare.install "bin/antigen.zsh"
  end

  def caveats; <<-EOS.undent
    To activate antigen, add the following to your ~/.zshrc:
      source #{HOMEBREW_PREFIX}/share/antigen/antigen.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write "source #{HOMEBREW_PREFIX}/share/antigen/antigen.zsh\n"
    system "zsh", "--login", "-i", "-c", "antigen help"
  end
end

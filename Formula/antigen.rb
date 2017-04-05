class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/releases/download/v1.4.1/v1.4.1.tar.gz"
  sha256 "a2f30020ff8414341d855e33b6dfdc4827cd2079e1f7297ef65cd9a380e66cd8"
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

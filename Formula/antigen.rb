class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle"
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/releases/download/v2.2.2/v2.2.2.tar.gz"
  sha256 "0a56f4bf57dac4f958782ff8f1796f9cb98f1742094285116a39ea6a63393377"
  head "https://github.com/zsh-users/antigen.git", :branch => "develop"

  bottle :unneeded

  def install
    pkgshare.install "bin/antigen.zsh"
  end

  def caveats; <<~EOS
    To activate antigen, add the following to your ~/.zshrc:
      source #{HOMEBREW_PREFIX}/share/antigen/antigen.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write "source #{HOMEBREW_PREFIX}/share/antigen/antigen.zsh\n"
    system "zsh", "--login", "-i", "-c", "antigen help"
  end
end

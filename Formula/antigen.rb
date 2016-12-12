class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.3.0.tar.gz"
  sha256 "e27bcc785c89fba0886fd03996dfc4bfb301ae6c07ed6a3305c4a0b45dcef004"
  head "https://github.com/zsh-users/antigen.git"

  bottle :unneeded

  def install
    zsh_function.install "bin/antigen.zsh" => "antigen"
  end

  def caveats; <<-EOS.undent
    To activate antigen, add the following to your ~/.zshrc:
      autoload -Uz antigen && antigen
    EOS
  end

  test do
    (testpath/".zshrc").write "autoload -Uz antigen && antigen\n"
    system "zsh", "--login", "-i", "-c", "antigen help"
  end
end

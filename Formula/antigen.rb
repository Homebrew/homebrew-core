class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/releases/download/v2.0.2/v2.0.2.tar.gz"
  sha256 "f47ec933b32c578abe8cb39b24e0ddd114ef5cc01b3c05bcb634859ead31493f"
  head "https://github.com/zsh-users/antigen.git", :branch => "develop"

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

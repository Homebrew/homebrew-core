class BashPreexec < Formula
  desc "preexec and precmd functions for Bash just like Zsh."
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.0.tar.gz"
  sha256 "0b75f66dc956cd205d9f0259fff23839d704699f5679ae37d0e43e8cf50b3b18"

  head "https://github.com/rcaloras/bash-preexec.git"

  bottle :unneeded

  def install
    (prefix/"etc/profile.d").install "bash-preexec.sh"
  end

  def caveats; <<-EOS.undent
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)

      [[ -f $(brew --prefix)/etc/profile.d/bash-preexec.sh ]] && . $(brew --prefix)/etc/profile.d/bash-preexec.sh

    EOS
  end

  test do
    # Just testing that the file is installed
    assert File.exist?("#{prefix}/etc/profile.d/bash-preexec.sh")
  end
end

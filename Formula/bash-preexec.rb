class BashPreexec < Formula
  desc "preexec and precmd functions for Bash just like Zsh."
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.1.tar.gz"
  sha256 "e9c96ceb54ca62cebf50191508971d8518245b9c2ad2598b4fd029f381ba17ab"

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

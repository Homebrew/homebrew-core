class BashPreexec < Formula
  desc "preexec and precmd functions for Bash just like Zsh."
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.3.tar.gz"
  sha256 "019a556c5ec77a6c5b4c53c0afbe6596b0d8eac2ffde076af44b0a1d5793cc7b"

  head "https://github.com/rcaloras/bash-preexec.git"

  bottle :unneeded

  def install
    (prefix/"etc/profile.d").install "bash-preexec.sh"
  end

  def caveats; <<-EOS.undent
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
      [ -f #{etc}/profile.d/bash-preexec.sh ] && . #{etc}/profile.d/bash-preexec.sh
    EOS
  end

  test do
    # Just testing that the file is installed
    assert File.exist?("#{prefix}/etc/profile.d/bash-preexec.sh")
  end
end

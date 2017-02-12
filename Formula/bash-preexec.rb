class BashPreexec < Formula
  desc "preexec and precmd functions for Bash just like Zsh."
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.2.tar.gz"
  sha256 "bf35c21ffdb8a48a908f1503c681017399e62e5580852e3e598e303bb86fc24d"

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

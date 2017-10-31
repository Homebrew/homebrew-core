class BashPreexec < Formula
  desc "preexec and precmd functions for Bash (just like Zsh)"
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.6.tar.gz"
  sha256 "d2c0c7698d02e72cb47e8bf9394e1773c33414f8c845311db9bc1a1f7c2a089b"

  head "https://github.com/rcaloras/bash-preexec.git"

  bottle :unneeded

  def install
    (prefix/"etc/profile.d").install "bash-preexec.sh"
  end

  def caveats; <<~EOS
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
      [ -f #{etc}/profile.d/bash-preexec.sh ] && . #{etc}/profile.d/bash-preexec.sh
    EOS
  end

  test do
    # Just testing that the file is installed
    assert_predicate testpath/"#{prefix}/etc/profile.d/bash-preexec.sh", :exist?
  end
end

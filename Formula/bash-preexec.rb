class BashPreexec < Formula
  desc "preexec and precmd functions for Bash (just like Zsh)"
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.5.tar.gz"
  sha256 "197f5107f84a4b4caadc57f908f2b72a911c95ae36412d1b166c4c1b20b2da8b"

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

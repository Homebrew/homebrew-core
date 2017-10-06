class BashPreexec < Formula
  desc "preexec and precmd functions for Bash (just like Zsh)"
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.3.4.tar.gz"
  sha256 "a3050e1672ebc2374e235ea7879f129a62dfddc95875ba90e86271a48f6548b9"

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
    assert_predicate testpath/"#{prefix}/etc/profile.d/bash-preexec.sh", :exist?
  end
end

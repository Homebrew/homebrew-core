class BashPreexec < Formula
  desc "Preexec and precmd functions for Bash (like Zsh)"
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.4.1.tar.gz"
  sha256 "5e6515d247e6156c99a31de6db58e9cbef53071806292a1ca10b7af74633a8c9"
  license "MIT"
  head "https://github.com/rcaloras/bash-preexec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72f047a0bb9e083b3c2a2bf491f8b3db94caa40f01710c03083ee005e2aa4454"
  end

  def install
    (prefix/"etc/profile.d").install "bash-preexec.sh"
  end

  def caveats
    <<~EOS
      Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
        [ -f #{etc}/profile.d/bash-preexec.sh ] && . #{etc}/profile.d/bash-preexec.sh
    EOS
  end

  test do
    # Just testing that the file is installed
    assert_predicate testpath/"#{prefix}/etc/profile.d/bash-preexec.sh", :exist?
  end
end

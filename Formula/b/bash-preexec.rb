class BashPreexec < Formula
  desc "Preexec and precmd functions for Bash (like Zsh)"
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/refs/tags/0.6.0.tar.gz"
  sha256 "1a987c0ef0e9cfa0391389327c5aef30166325b32666adde3daa9b809850cdd1"
  license "MIT"
  head "https://github.com/rcaloras/bash-preexec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d737f908e1981ebeeb2cc684951331f7dfb4ab8b0befc291c5da4b3f83fd7154"
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
    assert_path_exists testpath/"#{prefix}/etc/profile.d/bash-preexec.sh"
  end
end

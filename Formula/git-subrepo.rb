class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.3.1.tar.gz"
  sha256 "f36fb9e6ccb82b1200ba94c2b9c1db7fb683d93d2051ac92ab69c049f2529906"
  revision 1
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7d319ded76484efef8f34b45853e97c5d663cc2c4e76e91ed0f6a7fae1a8edb" => :sierra
    sha256 "f7d319ded76484efef8f34b45853e97c5d663cc2c4e76e91ed0f6a7fae1a8edb" => :el_capitan
    sha256 "f7d319ded76484efef8f34b45853e97c5d663cc2c4e76e91ed0f6a7fae1a8edb" => :yosemite
  end

  def install
    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"

    # Remove test for $GIT_SUBREPO_ROOT in completion script
    # https://github.com/ingydotnet/git-subrepo/issues/183
    inreplace "share/zsh-completion/_git-subrepo",
              /^if [[ -z $GIT_SUBREPO_ROOT ]].*?^fi$/m, ""

    mv "share/completion.bash", "share/git-subrepo"
    bash_completion.install "share/git-subrepo"
    zsh_completion.install "share/zsh-completion/_git-subrepo"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      assert_match(/cloned into/,
                   shell_output("git subrepo clone ../mod mod"))
    end
  end
end

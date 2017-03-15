class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.3.1.tar.gz"
  sha256 "f36fb9e6ccb82b1200ba94c2b9c1db7fb683d93d2051ac92ab69c049f2529906"
  revision 1
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "abd5fef76d76dd765af949e2f44bd55e3ae122319671e64f551172c20123dc13" => :sierra
    sha256 "23a7f23ad60d8fbb1e22177bc5862b6f5736f893582a63d121ca4eae4a389ce3" => :el_capitan
    sha256 "23a7f23ad60d8fbb1e22177bc5862b6f5736f893582a63d121ca4eae4a389ce3" => :yosemite
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

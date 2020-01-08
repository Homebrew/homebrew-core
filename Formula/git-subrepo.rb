class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.4.0.tar.gz"
  sha256 "e60243efeebd9ae195559400220366e7e04718123481b9da38344e75bab71d21"
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "140cae9bacff5e3b924a2cd1fd883bc54877755f1cb33d6842990ff4299907e1" => :catalina
    sha256 "1eb8d6ba0b5f819db7438497daa7b2067464a8b09b07afdb3109a145da99e494" => :mojave
    sha256 "ef78a20f6438aa9975c4aa8e65882b0f935e96f53d4e832e97fe3948d77e406e" => :high_sierra
    sha256 "ef78a20f6438aa9975c4aa8e65882b0f935e96f53d4e832e97fe3948d77e406e" => :sierra
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

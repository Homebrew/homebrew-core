class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.4.2.tar.gz"
  sha256 "64c473a8070b7cf7b0fbb9d9bff40381ebc6a57eaaa1bc17e66f2a5920dd1ef8"
  license "MIT"
  head "https://github.com/ingydotnet/git-subrepo.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "499beadca28680001847d8ee797f15595b629017a4b434e775ae4d3309277002" => :catalina
    sha256 "499beadca28680001847d8ee797f15595b629017a4b434e775ae4d3309277002" => :mojave
    sha256 "499beadca28680001847d8ee797f15595b629017a4b434e775ae4d3309277002" => :high_sierra
  end

  depends_on "bash"

  def install
    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"

    # Remove test for $GIT_SUBREPO_ROOT in completion script
    # https://github.com/ingydotnet/git-subrepo/issues/183
    inreplace "share/zsh-completion/_git-subrepo",
              /^if \[\[ -z \$GIT_SUBREPO_ROOT \]\].*?^fi$/m, ""

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

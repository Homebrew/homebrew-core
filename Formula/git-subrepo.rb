class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.4.3.tar.gz"
  sha256 "d2e3cc58f8ac3d90f6f351ae2f9cc999b133b8581ab7a0f7db4933dec8e62c2a"
  license "MIT"
  head "https://github.com/ingydotnet/git-subrepo.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "994bc2d7fbc2493b0098aa8ef6aa417168787ba35c3454bd95fbc17e2785682c" => :big_sur
    sha256 "f946b93c3cb112ee8c79bbdfb180991d3b5ab57d2709699253d438b59e5300d5" => :catalina
    sha256 "edec79b53d654b24091d8aff431784f965ca0a4469724d602c18ca652713a305" => :mojave
  end

  depends_on "bash"

  def install
    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"

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

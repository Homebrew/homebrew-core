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
    sha256 "dc532b9259999534520c4695392ccb28d5762ab9b9ecfd37d0457be6029b4ce1" => :big_sur
    sha256 "b129526636d9f095133421f59317abf144c77ad5aeb54f964fd6eab4aa2937af" => :arm64_big_sur
    sha256 "0e1c83339ad6f73952c8d4ae0c82b4cb0181d421d0a527a5e0a31f7cd3c3ac90" => :catalina
    sha256 "5465f88825a9a2361f0459d8e2dfb65a4e533c2106b2f8a644f295702085b711" => :mojave
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

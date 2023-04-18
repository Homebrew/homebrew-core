class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.4.5.tar.gz"
  sha256 "bb2f139222cfecb85fe9983cd8f9d572942f60097d6d736e2e6b01d1292e0a8a"
  license "MIT"
  head "https://github.com/ingydotnet/git-subrepo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a39768821ddd16240f8a467ef1a90b4e59ad609ae14f36ea4dedc81438ac8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a39768821ddd16240f8a467ef1a90b4e59ad609ae14f36ea4dedc81438ac8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a39768821ddd16240f8a467ef1a90b4e59ad609ae14f36ea4dedc81438ac8cf"
    sha256 cellar: :any_skip_relocation, ventura:        "1980304e4b65652e9ffd9b211844698ecf19b5a963819616681733fb98302b3a"
    sha256 cellar: :any_skip_relocation, monterey:       "1980304e4b65652e9ffd9b211844698ecf19b5a963819616681733fb98302b3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1980304e4b65652e9ffd9b211844698ecf19b5a963819616681733fb98302b3a"
    sha256 cellar: :any_skip_relocation, catalina:       "1980304e4b65652e9ffd9b211844698ecf19b5a963819616681733fb98302b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a39768821ddd16240f8a467ef1a90b4e59ad609ae14f36ea4dedc81438ac8cf"
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

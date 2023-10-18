class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.4.6.tar.gz"
  sha256 "6dcfce781007e7a755444c59e3622eb436e5671c197b8031eaf69fdbaea2b189"
  license "MIT"
  head "https://github.com/ingydotnet/git-subrepo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "918e4c676f1d656c649e59362d72da19bfb9ac4cafb38b0f0786b3801a1d173a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "198e49f8a5a9df95401bdb6b04e5cdf172ff2fc72cb224bc4c015b3d6f0e127d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198e49f8a5a9df95401bdb6b04e5cdf172ff2fc72cb224bc4c015b3d6f0e127d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "198e49f8a5a9df95401bdb6b04e5cdf172ff2fc72cb224bc4c015b3d6f0e127d"
    sha256 cellar: :any_skip_relocation, sonoma:         "34633bc09461fa9c46f9a2f024f43efe12cb43b93ee6b8ec53edf28abd7c3ce8"
    sha256 cellar: :any_skip_relocation, ventura:        "e070c11eb2fcffba7113d08541dbc52a43cc0171e59a2227adaf158a4378d3d8"
    sha256 cellar: :any_skip_relocation, monterey:       "e070c11eb2fcffba7113d08541dbc52a43cc0171e59a2227adaf158a4378d3d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e070c11eb2fcffba7113d08541dbc52a43cc0171e59a2227adaf158a4378d3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198e49f8a5a9df95401bdb6b04e5cdf172ff2fc72cb224bc4c015b3d6f0e127d"
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

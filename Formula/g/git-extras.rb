class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/refs/tags/7.2.0.tar.gz"
  sha256 "f570f19b9e3407e909cb98d0536c6e0b54987404a0a053903a54b81680c347f1"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce35fce3ffa8640beebbbc77f338d91e4f90c7111e3f4cd529eeba2969f9e29b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce35fce3ffa8640beebbbc77f338d91e4f90c7111e3f4cd529eeba2969f9e29b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce35fce3ffa8640beebbbc77f338d91e4f90c7111e3f4cd529eeba2969f9e29b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce35fce3ffa8640beebbbc77f338d91e4f90c7111e3f4cd529eeba2969f9e29b"
    sha256 cellar: :any_skip_relocation, ventura:        "ce35fce3ffa8640beebbbc77f338d91e4f90c7111e3f4cd529eeba2969f9e29b"
    sha256 cellar: :any_skip_relocation, monterey:       "ce35fce3ffa8640beebbbc77f338d91e4f90c7111e3f4cd529eeba2969f9e29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7167b10ce60d43bcde34c76cd8f1aec92d5d98d05f93e95b98fc140bee0d7b86"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-sync",
    because: "both install a `git-sync` binary"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zshrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end

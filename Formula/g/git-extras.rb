class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/refs/tags/7.4.0.tar.gz"
  sha256 "aaab3bab18709ec6825a875961e18a00e0c7d8214c39d6e3a63aeb99fa11c56e"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab7f49444bdd81c79d987f8e86668b225d6cc74f01b09ac91f7b35cde0a9bb98"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-delete-merged-branches", because: "both install `git-delete-merged-branches` binaries"
  conflicts_with "git-ignore", because: "both install a `git-ignore` binary"
  conflicts_with "git-standup", because: "both install `git-standup` binaries"
  conflicts_with "git-sync", because: "both install a `git-sync` binary"
  conflicts_with "ugit", because: "both install `git-undo` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "COMPL_DIR=#{bash_completion}", "INSTALL_VIA=brew", "install"
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

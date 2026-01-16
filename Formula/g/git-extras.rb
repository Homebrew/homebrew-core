class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/refs/tags/7.4.0.tar.gz"
  sha256 "aaab3bab18709ec6825a875961e18a00e0c7d8214c39d6e3a63aeb99fa11c56e"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "68e0ef44b443f683c0f8d21f1a72162ff1063377582b60855a7fbace9ad3a5ab"
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
    fish_completion.install "etc/git-extras.fish"
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

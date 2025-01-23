class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/refs/tags/7.3.0.tar.gz"
  sha256 "89bae1a05731f4aaafb04066ea0186e181117b74fcfbf89d686cf205459220b7"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c40b2cdc071464b0edf01e763b279111aa8ec557132a25d3385f7ee92783623"
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

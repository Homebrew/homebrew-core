class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/6.4.0.tar.gz"
  sha256 "d8943c0caab43e70c23890816a9775844d33261c40d5be03c1e012c276b1aa63"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75cbcd4fe8ad39801a46a6abadc8831aaacdb0bbf6f65eccc190c65c8b220985"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-utils",
    because: "both install a `git-pull-request` script"

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

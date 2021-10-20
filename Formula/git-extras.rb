class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/6.3.0.tar.gz"
  sha256 "8a218a0c8e10036d5ba14f26b70f994b0d11166b02ef3fed71c593cef026ec3d"
  license "MIT"
  head "https://github.com/tj/git-extras.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6d445a34c00d43c1a4804b4b93c34af758c968983779a0781a9ae7bdd0c1882"
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

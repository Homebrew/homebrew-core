class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/4.5.0.tar.gz"
  sha256 "cb099d9e155c3bf863f95dd91c72bcc2e05fb28e3ebce527cd70d1b517402615"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49889ba523c2dcbb773abad6d4ae0cc0d8d2179b9d5872953b1f208e52091571" => :high_sierra
    sha256 "49889ba523c2dcbb773abad6d4ae0cc0d8d2179b9d5872953b1f208e52091571" => :sierra
    sha256 "49889ba523c2dcbb773abad6d4ae0cc0d8d2179b9d5872953b1f208e52091571" => :el_capitan
  end

  conflicts_with "git-utils",
    :because => "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats; <<~EOS
    To load Zsh completions, add the following to your .zschrc:
      source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end

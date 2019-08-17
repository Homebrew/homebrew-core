class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/5.0.0.tar.gz"
  sha256 "7fb70af14c12119d184fe33f5f86046b7ad175ee81fa89e75fb54a5b3aff609a"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bd122f438ebe8d623169f24a5add6a4609a7e33782f15f09e98a9e8e4c5a5fc" => :mojave
    sha256 "5bd122f438ebe8d623169f24a5add6a4609a7e33782f15f09e98a9e8e4c5a5fc" => :high_sierra
    sha256 "3e50176046daa936eded6a4f5ac27d56fd05375c145c61889a050fdb3797d596" => :sierra
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

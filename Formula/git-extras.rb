class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/4.5.0.tar.gz"
  sha256 "cb099d9e155c3bf863f95dd91c72bcc2e05fb28e3ebce527cd70d1b517402615"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "77f2a8b3366b1f9016b4ef1a34a3d3b33f59d1fa8a7ffab65803ee7c0bdcd4dc" => :high_sierra
    sha256 "77f2a8b3366b1f9016b4ef1a34a3d3b33f59d1fa8a7ffab65803ee7c0bdcd4dc" => :sierra
    sha256 "77f2a8b3366b1f9016b4ef1a34a3d3b33f59d1fa8a7ffab65803ee7c0bdcd4dc" => :el_capitan
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

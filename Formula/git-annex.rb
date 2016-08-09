require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20160808/git-annex-6.20160808.tar.gz"
  sha256 "c729decece3dfc05366879b72328b5ebe4a86e77a32f634fcfa4dbebbb8799fd"
  head "git://git-annex.branchable.com/"

  bottle do
    cellar :any
    sha256 "9627ba509decc32a187afcc3fda6dcab2974db69a3c04e5005dde9bd3eae88ba" => :el_capitan
    sha256 "73f8961b8fd9a93e871dd1ff1379f63d3c78ee239782d1ffe79e7a4749779b4b" => :yosemite
    sha256 "33d9184557f8d18fb772310b75ec8ec797b86d96240627cac49931ac4453713e" => :mavericks
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "libmagic"
  depends_on "gnutls"
  depends_on "quvi"

  # Fixes CI timeout by providing a more specific hint for Solver
  # Reported 9 Aug 2016: "git-annex.cabal: persistent ==2.2.4.1"
  patch do
    url "https://github.com/joeyh/git-annex/pull/56.patch"
    sha256 "62ad81e3019f5c639708c679783e3f93e20996db1dc3577553ce90ab55fac9cf"
  end

  def install
    install_cabal_package :using => ["alex", "happy", "c2hs"], :flags => ["s3", "webapp"] do
      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    # We don't want this here or it gets "caught" by git-annex.
    rm_r "Library/Python/2.7/lib/python/site-packages/homebrew.pth"

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    assert !File.symlink?("Hello.txt")
    assert_match "add Hello.txt ok", shell_output("git annex add .")
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end

require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  revision 1
  head "git://git-annex.branchable.com/"

  stable do
    url "https://hackage.haskell.org/package/git-annex-6.20170520/git-annex-6.20170520.tar.gz"
    sha256 "f8cf9b44172ce1914c8be8134795c4197d02960b81a2ba596712cbd35e002717"

    # Fix "Utility/QuickCheck.hs:38:10: error: Duplicate instance declarations"
    # Upstream commit from 17 Jun 2017 "Fix build with QuickCheck 2.10."
    patch do
      url "http://source.git-annex.branchable.com/?p=source.git;a=patch;h=75cecbbe3fdafdb6652e95ac17cd755c28e67f20"
      sha256 "2d50b633b29895755c8cbe1b55262866f5c09fe346ee5d552edde5e141730de7"
    end

    # Fix two "git annex test" failures with QuickCheck 2.10
    # Upstream commit from 17 Jun 2017 "fix failing quickcheck properties"
    patch do
      url "http://source.git-annex.branchable.com/?p=source.git;a=patch;h=da8e84efe997fcbfcf489bc4fa9cc835ed131d3a"
      sha256 "3ab0dfe93e2f121818cce74dd76653a7acd8c2c97b34529b1684a640cabf79fc"
    end
  end

  bottle do
    sha256 "2ffab45fcf375b97300423adda199439ef2960f18d00c8d6425235d0a802072d" => :sierra
    sha256 "691d96c14406b08f89250edd2f8b665ebc88893ef4fca38f06c547ee2e45f857" => :el_capitan
    sha256 "4fe563338e2902807332c2f43168d327fed6101012ed3686bc69dc41f4ac6eaa" => :yosemite
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot" => :recommended

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

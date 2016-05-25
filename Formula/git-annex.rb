require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"

  head "git://git-annex.branchable.com/"

  stable do
    url "https://hackage.haskell.org/package/git-annex-6.20160511/git-annex-6.20160511.tar.gz"
    sha256 "85fc8853166fe57d91dc2776d5df4acb5911a91815f8aa12881928a1afe8ba01"

    # Can be removed once the library deps are worked out upstream of git-annex
    # Upstream commit "temporarily add cabal.config to support ghc 8.0.1 build"
    # https://github.com/joeyh/git-annex/commit/7b61c7f5d0fe76e9d2db9a61848611eeaa66c3d4
    # Regarding the aws library specifically, see the following:
    # https://github.com/aristidb/aws/issues/202
    # https://github.com/aristidb/aws/pull/204
    # https://github.com/aristidb/aws/pull/203
    resource "cabalcfg" do
      url "https://raw.githubusercontent.com/joeyh/git-annex/7b61c7f5d0fe76e9d2db9a61848611eeaa66c3d4/cabal.config"
      sha256 "c3a1b66113344f58b8d9cc4da37db5d2c83dabd0ec9b8d5adbda9b89cde0a559"
    end

    # Remove when >6.20160511 is released since this has been merged to HEAD
    # ghc 8.0.1 didn't like runner because it used Rank2Types
    # Reported 22 May 2016: http://git-annex.branchable.com/bugs/ghc_8.0.1_build_fixes
    patch do
      url "https://github.com/joeyh/git-annex/commit/fe944a96d3e2b8c755970bd28641925617f19613.patch"
      sha256 "311282f6df5f10488ed0bd0e093757f6fd4c1b8d31c937ddceaa8c4303183542"
    end
  end

  bottle do
    sha256 "37d8e4c41efe18de3074a2133a87efb45db211ac19b56c9069c576518d1d6947" => :el_capitan
    sha256 "480e07ab5a296ef97b1072764664078eae8d34a2b3df077ebc51ed1a31b60d24" => :yosemite
    sha256 "ec01045dd5059e8b5df57b4c4f6751d853b8b849cec57862ff6369ffd35e6181" => :mavericks
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

  def install
    buildpath.install resource("cabalcfg") if build.stable?

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

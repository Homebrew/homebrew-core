require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20170520/git-annex-6.20170520.tar.gz"
  sha256 "f8cf9b44172ce1914c8be8134795c4197d02960b81a2ba596712cbd35e002717"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "5767f473ff0fa5c36c290be9bd90ba905ad9c4b291f735f0e3dffa1d926337ca" => :sierra
    sha256 "6c6b4327c036ae83b7d7f93fd15886c014c6f240a3b8460c1f042bbb8c7bad22" => :el_capitan
    sha256 "a3f52f6ea6b9084b4aa569f1ee55f39d4bfd1dc9ed978fdb21cea49a3308f9d9" => :yosemite
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
    # Workaround for "error: redefinition of enumerator '_CLOCK_REALTIME'" and
    # other similar errors.
    # Reported 11 Jun 2017 https://github.com/haskell-foundation/foundation/issues/342
    if MacOS.version == :el_capitan
      (buildpath/"cabal.config").write("constraints: foundation < 0.0.10\n")
    end

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

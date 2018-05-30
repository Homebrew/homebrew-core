require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20180529/git-annex-6.20180529.tar.gz"
  sha256 "a5ebeeef3a2a1c71e08592fed6ac149a3cda1c397bad8c1413f40d9a3da9a0e7"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "983c506669773fc0ee3892ce74d8818c24b44c35d3a5a3bd6cf2f049ac35f0e5" => :high_sierra
    sha256 "62b6068b13ddcddfb022407bab5be7bf775137744c4d9732e0a4b2935bc63da5" => :sierra
    sha256 "586b7a92d08a44ccc73b64fd1255b0d47ce68e1a9226b3e4f12c24c2b2af7fb9" => :el_capitan
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot" => :recommended

  def install
    # Reported 28 Feb 2018 to aws upstream https://github.com/aristidb/aws/issues/244
    # This is already resolved in aws 0.20 but we can't move to 0.20 until
    # esqueleto 2.6.0 ships. See https://github.com/bitemyapp/esqueleto/issues/88
    install_cabal_package "--constraint", "http-conduit<2.3",
                          :using => ["alex", "happy", "c2hs"],
                          :flags => ["s3", "webapp"] do
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

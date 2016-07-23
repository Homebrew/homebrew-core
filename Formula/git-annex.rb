require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  head "git://git-annex.branchable.com/"

  stable do
    url "https://hackage.haskell.org/package/git-annex-6.20160619/git-annex-6.20160619.tar.gz"
    sha256 "5acc80dfb86d8f568819256a428f04794bff4c654389692f27a7bf0877ebe12f"

    # Upstream commit "cabal constraints for aws and esqueleto"
    # Upstream aws issue: https://github.com/aristidb/aws/issues/206
    # Upstream esqueleto issue: https://github.com/prowdsponsor/esqueleto/issues/137
    patch do
      url "https://github.com/joeyh/git-annex/commit/18e458db.patch"
      sha256 "75c3f7426e492ea48062f9922badae5c7809f2494f128e41f9d3e148fb9daa50"
    end
  end

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

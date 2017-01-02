require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20170101/git-annex-6.20170101.tar.gz"
  sha256 "5fbf88652a84278275d9d4bec083189f590b045e23a73bfe8d395c3e356e3f53"
  head "git://git-annex.branchable.com/"

  bottle do
    cellar :any
    sha256 "3d51a7ef95e0ab4885d820ae2afbefc4c1b54c7200bc47df5e79a7715a13d06c" => :sierra
    sha256 "53e80adf5a72a12dadbbb7541ce7bab4354e74372a5a6848da3fa317c7289f8c" => :el_capitan
    sha256 "5b6026b3cecfefe1494e41c851ab3b22599ea510d8a11ec51b2d58503271ef90" => :yosemite
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
  depends_on "xdot" => :recommended

  # new maintainer's fork, which will be in Hackage shortly
  resource "esqueleto" do
    url "https://github.com/bitemyapp/esqueleto.git",
        :revision => "bfc8502dbf23251b3794bcd0370a100211297cc5"
    version "2.5.0-alpha1"
  end

  def install
    cabal_sandbox do
      (buildpath/"esqueleto").install resource("esqueleto")
      inreplace "esqueleto/esqueleto.cabal",
        "base                 >= 4.5     && < 4.9",
        "base                 >= 4.5     && < 5.0"
      cabal_sandbox_add_source "esqueleto"
      install_cabal_package :using => ["alex", "happy", "c2hs"], :flags => ["s3", "webapp"] do
        # this can be made the default behavior again once git-union-merge builds properly when bottling
        if build.with? "git-union-merge"
          system "make", "git-union-merge", "PREFIX=#{prefix}"
          bin.install "git-union-merge"
          system "make", "git-union-merge.1", "PREFIX=#{prefix}"
        end
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

require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  revision 1
  head "git://git-annex.branchable.com/"

  stable do
    url "https://hackage.haskell.org/package/git-annex-6.20161210/git-annex-6.20161210.tar.gz"
    sha256 "b568cceda32908e7cd66b34181811d4da3d3197d71009eac20c1c4c4379f6381"

    # Remove for git-annex > 6.20161210
    # Upstream commit from 20 Dec 2016 "Fix build with directory-1.3."
    # https://github.com/joeyh/git-annex/commit/e312ec37506f4b07beb0e082fedbdd06aed24c42
    patch :DATA
  end

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

  # Remove when aws > 0.14.1 is released on Hackage
  # Adds http-client 2.2 support
  # Merged PR https://github.com/aristidb/aws/pull/213
  # Original issue https://github.com/aristidb/aws/issues/206
  resource "aws" do
    url "https://github.com/aristidb/aws.git",
        :revision => "c8806dcbb58604381698e394c0e7798b704776db"
  end

  resource "esqueleto-2.4.3" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3.orig.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3.orig.tar.gz"
    sha256 "bf555cfb40519ed1573f7bb90c65f693b9639dfa93fc2222230d3ded6e897434"
  end

  # Patch for esqueleto to be able to use persistent 2.6
  # https://github.com/joeyh/git-annex/commit/6416ae9c09f54c062c05cc686ade35c2e08c1434
  # https://github.com/haskell-infra/hackage-trustees/issues/84
  # https://github.com/prowdsponsor/esqueleto/issues/137
  resource "esqueleto-newer-persistent-patch" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3-5.debian.tar.xz"
    mirror "https://mirrors.kernel.org/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3-5.debian.tar.xz"
    sha256 "b152307e6c8f5f79d070bcadcf05d32c52a205bd2bacc578686c2aa01491aff6"
  end

  def install
    cabal_sandbox do
      (buildpath/"aws").install resource("aws")

      # Remove for aws > 0.14.1
      # Reported 21 Dec 2016 https://github.com/aristidb/aws/issues/215
      inreplace "aws/aws.cabal", /(directory +>= 1.0 +&& <) 1.3,/, "\\1 1.4,"

      (buildpath/"esqueleto-2.4.3").install resource("esqueleto-2.4.3")
      resource("esqueleto-newer-persistent-patch").stage do
        system "patch", "-p1", "-i", Pathname.pwd/"patches/newer-persistent",
                        "-d", buildpath/"esqueleto-2.4.3"
      end
      cabal_sandbox_add_source "aws", "esqueleto-2.4.3"
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

__END__
diff --git a/Utility/SystemDirectory.hs b/Utility/SystemDirectory.hs
index 3dd44d1..b9040fe 100644
--- a/Utility/SystemDirectory.hs
+++ b/Utility/SystemDirectory.hs
@@ -13,4 +13,4 @@ module Utility.SystemDirectory (
	module System.Directory
 ) where

-import System.Directory hiding (isSymbolicLink)
+import System.Directory hiding (isSymbolicLink, getFileSize)

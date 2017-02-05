require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20170101/git-annex-6.20170101.tar.gz"
  sha256 "5fbf88652a84278275d9d4bec083189f590b045e23a73bfe8d395c3e356e3f53"
  revision 2
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "777440d787bdec719faf3d5e3b524205c68fa15ecf4eed421ffb1d85ff67de10" => :sierra
    sha256 "910aa25bda380da29e781597cadc949a06ccd071200e474128b4b5d59e2bf7e9" => :el_capitan
    sha256 "7b52fbdc431c8d073eaa1b56f4dac158f6c27b1917f6da9468752f0d1679a9f3" => :yosemite
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

  def install
    # aws-0.16 compatibility
    # Avoid the build failure "Remote/S3.hs:224:49: error: The constructor
    # 'S3.UploadPartResponse' should have 1 argument, but has been given 2"
    # Fix taken from upstream report from 5 Feb 2017 https://git-annex.branchable.com/bugs/aws_0.16_breaking_changes/
    inreplace "Remote/S3.hs",
      "S3.UploadPartResponse _ etag <- sendS3Handle h req",
      "S3.UploadPartResponse { S3.uprETag = etag } <- sendS3Handle h req"

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

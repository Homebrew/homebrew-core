class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-8.20211011/git-annex-8.20211011.tar.gz"
  sha256 "8dc76be8821227601eaca42b4cf08c02f8296984d08649cf6d7655188348470b"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 big_sur:      "3d05d2c831ad829282da8bd8f168114dac80b2b12334fd1a5dce39b7bf0a9da6"
    sha256 cellar: :any,                 catalina:     "6d91da4af43b7a08e707d6ba5b98d559f84e9d0ae6bb0c419eea7403b6cb346d"
    sha256 cellar: :any,                 mojave:       "bc747428916af1f7d63cd15a63dca3a45e1247286a0fae755ec8f51525ed1ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "85f9bbe741faeaac654a8929d6aabe15a767528a38b0e5c97e2b832c49f27c95"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args,
                    "--flags=+S3"
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  service do
    run [opt_bin/"git-annex", "assistant", "--autostart"]
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
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    # make sure the various remotes were built
    assert_match shell_output("git annex version | grep 'remote types:'").chomp,
                 "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg hook external"

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

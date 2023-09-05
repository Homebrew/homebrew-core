class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230828/git-annex-10.20230828.tar.gz"
  sha256 "0b3469d932f0d8f133d79b3b8efc770d95e7db74f99c14679b494bdec840665d"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c67d186fa14ac1d27ae203a422182daa0ad0566fe8c77876f2d028a913797f42"
    sha256 cellar: :any,                 arm64_monterey: "e9ee8eb396a9ebe8696c366275163e4f270d626b074367925e5b0bd047d02699"
    sha256 cellar: :any,                 arm64_big_sur:  "0e70a0a2050e3690b531fcaa03479b0e6f1c9cf29ada54f58febdd9bd4bee644"
    sha256 cellar: :any,                 ventura:        "ff4ceba69c808a598c876510ef2993a0f9f91e4b959941cbf63e958cd2577700"
    sha256 cellar: :any,                 monterey:       "63967797e338ec30573a9e0fd1678f0b2f91454611a6faac48922d2fbf0915c8"
    sha256 cellar: :any,                 big_sur:        "20e644c65c61bb258f922175e34a9a1b015ba2782f9fd3d4e04c9de4cc8535da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa9995951ffae58290ffd24586b93e5a93aeb967e754adf153099e6b2cdf17b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3"
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

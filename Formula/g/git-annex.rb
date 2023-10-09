class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230926/git-annex-10.20230926.tar.gz"
  sha256 "e7ded189aa10b7926ec8624a30755c63d117b59d2d714c5f79b0b1962f70a41a"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59d124ef423c9f6e6bfb92b06f74a0d20855f19c688d705c7c8aa96328f98158"
    sha256 cellar: :any,                 arm64_ventura:  "72111a427c64eeded953fdf5da51dbc2b7463d3a4e649d5cf75b50dd785fcabf"
    sha256 cellar: :any,                 arm64_monterey: "54d201f6cca9371551b665aaba0211651e527f253361555cc6486cf136b6c5ca"
    sha256 cellar: :any,                 sonoma:         "578d2c2fd6a6eca84f97333a4a9fbd99e73a19122e7ccb26c50be35e46643e30"
    sha256 cellar: :any,                 ventura:        "31f7af0aee41392c0e319e23c708a5a33347327bc35c072bf7133825d0655226"
    sha256 cellar: :any,                 monterey:       "1716c05f2eb5ced147458dd23b33e3cbf18f54e403632a617be3a390be318751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c7abeed7e3d80b67c2b79a039f9f74a6a84fa32be4e5bd84def04bd71ffafc2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  def install
    # https://github.com/aristidb/aws/issues/288
    cabal_args = std_cabal_v2_args + ["--constraint=attoparsec-aeson<2.2.0.0"]
    system "cabal", "v2-update"
    system "cabal", "v2-install", *cabal_args, "--flags=+S3"
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

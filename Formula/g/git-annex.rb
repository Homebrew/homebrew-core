class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20260115/git-annex-10.20260115.tar.gz"
  sha256 "6307cfd60603c35df0aed9c0b7cc8932bc23c73a9a341bc3e1ccc61678fe295e"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "303a1f5cd4526ae67c53b1a83e5466bdef1617948c2d21c158b69ecc0450ca67"
    sha256 cellar: :any,                 arm64_sequoia: "5fc28272b5eaa9b53c050682c51f031a757374b31c4c0cb6e912a15e2b2fb23f"
    sha256 cellar: :any,                 arm64_sonoma:  "eb0fa0a1915ec5068dcd38bc4925235aad5daea93635cc65ef6e21b6ffa0a0e6"
    sha256 cellar: :any,                 sonoma:        "b27a5f6643e092346a03217b9d71212e39d66722301062897b983b23b9d41c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba3ebf69a4438bf90d58ffdf1a8aabe97a4e29d4019e8ae915df8a89c67193a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6898a87a439921cbeac6d21700a4445ac269058df9b6ed02af2f7a4c48e5089"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "--flags=+S3 +Servant"
    bin.install_symlink "git-annex" => "git-annex-shell"
    bin.install_symlink "git-annex" => "git-remote-annex"
    bin.install_symlink "git-annex" => "git-remote-tor-annex"
  end

  service do
    run [opt_bin/"git-annex", "assistant", "--autostart"]
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    refute_predicate (testpath/"Hello.txt"), :symlink?
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_predicate (testpath/"Hello.txt"), :symlink?

    # make sure the various remotes were built
    assert_match "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external",
                 shell_output("git annex version | grep 'remote types:'").chomp

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

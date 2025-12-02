class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20251114/git-annex-10.20251114.tar.gz"
  sha256 "5a1dae4352a36bb22cb5810b6cc0334593b06dd42a4d83623e09ff879f178766"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1238e8e583e91b930c069219dc7eaad1faa92d783e00ac4c9873be7477d70a02"
    sha256 cellar: :any,                 arm64_sequoia: "e0c94e88452063d89435776e61839080ca193ee054a1a2a3622f3f9105be30f1"
    sha256 cellar: :any,                 arm64_sonoma:  "02ff5d809d81577c08128c8eb73e158f0320addcd6c6f17133f69a4711c15f7f"
    sha256 cellar: :any,                 sonoma:        "b8aa9623b11168160e8f63acea601ee51192fcfaed40a197c4e51b5acff1b5ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c12bec47c9fc5eab088de27adbe872a5066845b490868ead466f4262e5821840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b359fe9d22279efccbebbdbb28b6ab0104404d4bbcc0711ab022572f524486"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3 +Servant"
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

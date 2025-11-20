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
    sha256 cellar: :any,                 arm64_tahoe:   "d2c1613aee9678c3e05f01a7120e71fb267d2727a9d2b90414b038e4c7f9b74c"
    sha256 cellar: :any,                 arm64_sequoia: "14b840ff145bef962de4e67b5e8c1624ff7c4adaaf0eaf73dc9ac2f99e6e0a7e"
    sha256 cellar: :any,                 arm64_sonoma:  "2eac7fda8cb3c02726e30ea4e298431af52212c520efd499be96152948b5dfbb"
    sha256 cellar: :any,                 sonoma:        "05b2db23c49a5c908a9f25df9fdf47d4c9adc51dbe3f75c91bc707b67fcc0965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bd521e8374cb6168df7d312a6d55695022d35d72e4bc38c281077f49e58011e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d2000e80267280b08eed65c47d0b73afd2712df72d46b6cb4068f98563bb39d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

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

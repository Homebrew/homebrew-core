class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250828/git-annex-10.20250828.tar.gz"
  sha256 "a4fa952cd35a548182965507a6bccddc1c0acfaa31aa2ef49c176b10edc13187"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47d6abacf43d0fe49d170c3938509491c54d4d342794ba06cd1666b5dcd434e9"
    sha256 cellar: :any,                 arm64_sequoia: "8561c60c88793801ac71225bdda9241ccb3cb1445458eb7d6d0b1bcc82cb3824"
    sha256 cellar: :any,                 arm64_sonoma:  "b89cfccefbc9a0ca1cf54b18f314cad05f182ecc58e679d6d67fe793bb95a31e"
    sha256 cellar: :any,                 arm64_ventura: "d8c71ff887cb7937bf32552777f3fa793329d00e16c78bfa801cce064e9f0e12"
    sha256 cellar: :any,                 sonoma:        "0f3195af84dbb1d3a2a3709ee9ab2358350c634a768eb2b1b8d3a580091941b6"
    sha256 cellar: :any,                 ventura:       "07b6bbcbc4dd3358ee2f5e1a73bb4cf8bceb56daaeac4f40a5780b61b12fd9be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3d7e2758537deda6e58bc68526e13d436ff17c76d0e880310391546e57f301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90f7266472ea1e67a66d4930a290e01c39c5eab820676393d51c02f3519f0d6"
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

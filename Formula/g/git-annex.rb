class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20260901/git-annex-10.20260901.tar.gz"
  sha256 "f7843f937103819b93d7c436410ac5cd2db0a8863d14eabeb15712f2bfd74582"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6336d24d59a128cb03b0df5c7c91e4c2f27813104354cbc29f7aec4c98d84d66"
    sha256 cellar: :any, arm64_tahoe:       "4cda8ae78638da2c565fc647da1f1ac89f68abb520667e1b576338f69d0d1668"
    sha256 cellar: :any, arm64_sequoia:     "0b746e311ac679111567b04a38a7971b146995f212403bf94f283f66dcac9318"
    sha256 cellar: :any, arm64_sonoma:      "18334bbad00bc354db80fb38f554967525862cd8a5d8e8cb62056a2bab7af5e3"
    sha256 cellar: :any, arm64_linux:       "f03f332529b3663beb1b563121dfcf757afbd3f553cb6fa95f634037d6bea750"
    sha256 cellar: :any, x86_64_linux:      "dc9d64a74745c070a8095d2a1e392bc55945b63ec3d1ae258a3a801b465dbb40"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      # Workaround to build with GHC 9.14
      "--allow-newer=base,template-haskell",
      # Workaround for https://github.com/yesodweb/yesod/issues/1917
      "--constraint=ram<0",
      # Workaround for API breaking release of magic
      "--constraint=magic<2",
      # Workaround for QuickCheck 2.17+ providing its own `Arbitrary (NonEmpty a)`
      # Upstream fix in commit 16cd931e9383ef295e4faf97f51c6fdfd2b9c61c, unreleased as of 10.20260901
      "--constraint=QuickCheck<2.17",
      # Unbundle sqlite
      "--constraint=persistent-sqlite +systemlib +use-pkgconfig",
    ]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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

class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250320/git-annex-10.20250320.tar.gz"
  sha256 "b1c426ba737291d1e432d5062784ecd25fc14a48407e030d34c48ceed40a5a0e"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6292a545595aeecf4f75821fbd2283ae3db46bc68510a5997df5956ac614bb5a"
    sha256 cellar: :any,                 arm64_sonoma:  "93e496806299244a4c2d089eb059487369faa70e00dfcf49488726b2a618fcf7"
    sha256 cellar: :any,                 arm64_ventura: "878c50e6019fff151c0b2bef77ce0a05ff03b0767991cad0481d549fa3da1a75"
    sha256 cellar: :any,                 sonoma:        "c4809e7cca854c330d3cd8eadec021b88187bf5928a969863bc8952551393440"
    sha256 cellar: :any,                 ventura:       "f6061e6d6d03f90c5d3e7dc2684a75c759f7824648aa42d6408214e1200f74f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa9563d30156553cbfc134cbbcbeefe81820395d1152caf954f9a03c619f61a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # Work around https://github.com/yesodweb/yesod/issues/1854 with constraint
    # TODO: Remove once fixed upstream
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3", "--constraint=wai-extra<3.1.17"
    bin.install_symlink "git-annex" => "git-annex-shell"
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

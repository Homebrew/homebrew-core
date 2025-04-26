class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250416/git-annex-10.20250416.tar.gz"
  sha256 "657e830ff6fa6de116e600f50fd14dda4a0e36250f5a3216255e1c560f6fa409"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32408f862fac2d71c027c6670d30028ef9525d88ad3b7171a7c05024d76cf42c"
    sha256 cellar: :any,                 arm64_sonoma:  "d708ae4e693a34da0dcf1fa1cdc355f6fb6ff67aa5c0b4d86ff76a221a7cfe45"
    sha256 cellar: :any,                 arm64_ventura: "34cebd05c2a7b6fb70ffae9727d96590f0b90ca1c11d676abf11156d707e0609"
    sha256 cellar: :any,                 sonoma:        "4eaef74f193dd44c5956759b06308361827fa4d1fdd6a2b34b8ca6127f1cff54"
    sha256 cellar: :any,                 ventura:       "b83e57e99f8964a6059ceeb3f1d3b1dec25e751a0e5e2ec77aad54fc8fcc8946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1237c40a0fab841d15d05cdf0a46d3e1adf15ca442fc601cdd8fc9988ca9be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1720688c0d3565d2eff67353a7b8895a092788122ac7b28d7724a586786866"
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

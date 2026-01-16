class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20251215/git-annex-10.20251215.tar.gz"
  sha256 "b8d7c5e1efe0f075c26c5848f9b4173be7bde0f6eabc180ef3051d675c0db69f"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b7b56e42d6f3fad823971db9efda9da346f8696205e5d8bc4d8e41888c863ee"
    sha256 cellar: :any,                 arm64_sequoia: "ad5aa73b50f62f4174cf1034a2637a004ca0c697b6212075e73f86ad6c0475c6"
    sha256 cellar: :any,                 arm64_sonoma:  "76cae6f044e5abf2d99166805d28b1aff7d73bdec33f9ac9ac15db2debfdb46d"
    sha256 cellar: :any,                 sonoma:        "1082a23bac2286d2f3414b80cf4a752d11adedab747185739e6c5c7cb1a8fd54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b949a2e7ac849b71ceaa970fb3dba324da669dcf8e08dc1a4d6894471a039a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7604c20569aa4e22e0c3f9e694a8c0c198411bd448b6e2648e90d16f4ad8c1ca"
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

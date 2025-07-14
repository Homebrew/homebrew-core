class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250630/git-annex-10.20250630.tar.gz"
  sha256 "03df602f2f72110d5a782a760399b64a57d37661f84aed6612d9d62d727459ed"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "479b8a4312236700a75f5d7ce9f978e4caf3a0dc557733c27d28360e040a4692"
    sha256 cellar: :any,                 arm64_sonoma:  "cf852d739508cb7be0e0916bb7d03f0773d5cd79a5be8da3631c83a13dfd4106"
    sha256 cellar: :any,                 arm64_ventura: "dbcc125879a94b74f26022518f64ad975c88bf794e6ef3689345167f1e81d7b9"
    sha256 cellar: :any,                 sonoma:        "74c4a5a1283979814b7a0e2541d635b6ba1bb862257251857d7e6aa954b60287"
    sha256 cellar: :any,                 ventura:       "3667b98e16d8908e73276a28d8d4da1881e505a38a2ee838ff79abc36b831b53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466998bdc019abab7b61e99bb150b3b334b69a2f9b2770ec82e36b371fed1f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573e3a965f1333a85422a93acf8eeda885019b2d8f60c710e8d8c58d32344669"
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

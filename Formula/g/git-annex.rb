class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20260717/git-annex-10.20260717.tar.gz"
  sha256 "e0802511e0c90852f52997520668b70cfa1e57fc268d996564c24a289ea6e406"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cf230a4073c083f4eb72e854d59107767ef76390a9b02500fc4f536d7e36b36d"
    sha256 cellar: :any, arm64_sequoia: "23741b3f18473205a77787f70d8f943da1813bde12e725da71ada66ca305da08"
    sha256 cellar: :any, arm64_sonoma:  "a86117168883797e8227aa03293ae9aeafd5d38de3bc8b9f7a81c1dcfc947adf"
    sha256 cellar: :any, sonoma:        "4750c8730326c22c4524b7d37415a874618c26c98960e992f2b24dd7fb6151ff"
    sha256 cellar: :any, arm64_linux:   "4079bd35e9e0623080537513dbf92b69cbe9c49068d9bea3544cca94d94e15c7"
    sha256 cellar: :any, x86_64_linux:  "9fad24db209821bcfec74e91053f9de36653d46f99cc751b06996fe7e4cbd295"
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

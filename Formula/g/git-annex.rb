class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250520/git-annex-10.20250520.tar.gz"
  sha256 "2931e8bcb0b2135e419d5a0b8143648be5a049c3a55305412f0b4236ea250b97"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58ccfdd7747aa59eec9f4ad00b7013aa763786942fb0ca998f2d08935df336a6"
    sha256 cellar: :any,                 arm64_sonoma:  "9c3c1178fa10d6efcb315450af7e548ae8d301d866153cca9bb0d3914be52e82"
    sha256 cellar: :any,                 arm64_ventura: "fd6a81d2c7e98ddf9e7d55c4ebece3b717dacbd062ae0a55feb8e7026b85afd9"
    sha256 cellar: :any,                 sonoma:        "81aa261ec5050767a1efdbd45a7514cf273449f231b37f3622a2b7c5d970b9d4"
    sha256 cellar: :any,                 ventura:       "69d5ce172305738db211b0f812e2d2612e86a605f864b477faa85ae553af62ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8195e1b34077507ac67ff1da6bc069ddbb6cae82769014bbb254069c639910a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1200624fb242ca289b0d3b0c4a77a552e4be78dd06fd662e3fc51e446bd070fa"
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
